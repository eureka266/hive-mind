#!/usr/bin/env python3
"""Render HiveMind email content into fixed HTML templates.

Input is a JSON file. Supported modes:

1. Standard injected body:
{
  "template_id": "marketing",
  "language": "en",
  "body_html": "<p>Hello...</p>"
}

2. Static template (optionally replaces variables):
{
  "template_id": "product_update",
  "variables": {
    "plan_quota": "1,000",
    "top_up_unit_price": "0.20"
  }
}
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

from bs4 import BeautifulSoup


ROOT = Path(__file__).resolve().parent
TEMPLATES_DIR = ROOT / "templates"

FONT_FAMILIES = {
    "en": "'DM Sans','Microsoft YaHei','PingFang SC',Arial,sans-serif",
    "zh": "'Microsoft YaHei UI','微软雅黑','PingFang SC',Helvetica,Arial,sans-serif",
    "es": "-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif",
    "ja": "'Yu Gothic','Meiryo','Microsoft YaHei UI',Helvetica,Arial,sans-serif",
    "pt-BR": "-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif",
    "ru": "'Arial','Helvetica Neue','Lucida Grande',sans-serif",
    "zh-Hant": "'Microsoft JhengHei','PingFang TC','Apple LiGothic',Helvetica,Arial,sans-serif",
    "ko": "'Malgun Gothic','Apple SD Gothic Neo','Nanum Gothic',Helvetica,Arial,sans-serif",
}

TEMPLATES = {
    "product_update": {
        "name": "Product Update (结构化产品更新邮件)",
        "file": "product_update.html",
        "sender": "Product Team",
        "static": True,
    },
    "marketing": {
        "name": "Marketing (付费用户营销/教育/采用)",
        "file": "marketing.html",
        "sender": "Product Team",
    },
    "sales": {
        "name": "Sales (售前触达/免费用户转化)",
        "file": "sales.html",
        "sender": "Sales Team",
    },
}

FREE_FORM_WRAPPER = (
    "<!doctype html><html><head><meta charset=\"utf-8\">"
    "<style>body{{font-family:{font};font-size:15px;line-height:1.6;"
    "color:#222;max-width:680px;margin:0 auto;padding:24px 20px;}}</style>"
    "</head><body>{body}</body></html>"
)


def load_template(template_id: str) -> str:
    if template_id not in TEMPLATES:
        raise ValueError(f"Unknown template_id: {template_id}")
    path = TEMPLATES_DIR / TEMPLATES[template_id]["file"]
    return path.read_text(encoding="utf-8")


def assemble_free_form_html(body_html: str, language: str = "en") -> str:
    font = FONT_FAMILIES.get(language, FONT_FAMILIES["en"])
    return FREE_FORM_WRAPPER.format(font=font, body=body_html)


def assemble_email(
    template_id: str,
    body_html: str,
    language: str = "en",
    suppress_signature: bool = False,
) -> str:
    template_html = load_template(template_id)

    if suppress_signature:
        start_marker = "<!-- SIGNATURE_START -->"
        end_marker = "<!-- SIGNATURE_END -->"
        start = template_html.find(start_marker)
        end = template_html.find(end_marker)
        if start != -1 and end != -1:
            template_html = template_html[:start] + template_html[end + len(end_marker) :]

    soup = BeautifulSoup(template_html, "html.parser")
    body_div = soup.find("div", class_="email-body")
    if not body_div:
        body_div = soup.find("div", style=lambda s: s and "line-height:1.8" in s)
    if not body_div:
        raise ValueError(f"Could not find body content div in template {template_id}")

    font_family = FONT_FAMILIES.get(language, FONT_FAMILIES["en"])
    current_style = body_div.get("style", "")
    current_style = re.sub(
        r"font-family:[^;]+;",
        f"font-family:{font_family};",
        current_style,
    )
    body_div["style"] = current_style
    body_div.clear()
    body_div.append(BeautifulSoup(body_html, "html.parser"))
    return str(soup)


def render(payload: dict[str, Any]) -> str:
    template_id = payload.get("template_id")
    language = payload.get("language", "en")

    if not template_id:
        body_html = payload.get("body_html")
        if not body_html:
            raise ValueError("Provide template_id or body_html for free-form rendering")
        return assemble_free_form_html(body_html, language)

    if TEMPLATES.get(template_id, {}).get("static"):
        html = load_template(template_id)
        variables = payload.get("variables", {})
        for key, value in variables.items():
            html = html.replace("{{" + key + "}}", str(value))
        return html

    body_html = payload.get("body_html")
    if not isinstance(body_html, str) or not body_html.strip():
        raise ValueError(f"{template_id} requires non-empty body_html")
    return assemble_email(
        template_id,
        body_html,
        language,
        bool(payload.get("suppress_signature", False)),
    )


def main() -> None:
    parser = argparse.ArgumentParser(description="Render HiveMind email HTML.")
    parser.add_argument("--input", required=True, help="Path to JSON payload.")
    parser.add_argument("--output", required=True, help="Path to write rendered HTML.")
    parser.add_argument("--list-templates", action="store_true")
    args = parser.parse_args()

    if args.list_templates:
        print(json.dumps(TEMPLATES, ensure_ascii=False, indent=2))
        return

    payload = json.loads(Path(args.input).read_text(encoding="utf-8"))
    html = render(payload)
    output = Path(args.output)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(html, encoding="utf-8")
    print(str(output))


if __name__ == "__main__":
    main()
