from misaka import (Markdown, HtmlRenderer, EXT_NO_INTRA_EMPHASIS, EXT_AUTOLINK, EXT_TABLES, EXT_FENCED_CODE,
    EXT_STRIKETHROUGH, EXT_LAX_HTML_BLOCKS, EXT_SPACE_HEADERS, HTML_HARD_WRAP)
import pygments
from pygments.lexers import get_lexer_by_name
from pygments.formatters import HtmlFormatter

class HtmlPygmentsRenderer(HtmlRenderer):
  def block_code(self, code, language):
    language = language or "text"
    lexer = get_lexer_by_name(language, encoding="utf-8", stripnl=False, stripall=False)
    formatter = HtmlFormatter(nowrap=True)
    rendered_code = pygments.highlight(code, lexer, formatter)
    return "<div class=\"highlight\">{0}</div>".format(rendered_code)

pygments_renderer = HtmlPygmentsRenderer(HTML_HARD_WRAP)
markdown_renderer = Markdown(pygments_renderer, EXT_NO_INTRA_EMPHASIS | EXT_AUTOLINK | EXT_TABLES | EXT_FENCED_CODE |
    EXT_STRIKETHROUGH | EXT_LAX_HTML_BLOCKS | EXT_SPACE_HEADERS)
#md_text = """
#some ~~markdown~~ text `blah`
#
#```ruby
#def foo(bar); puts "bar" end
#```
#"""
#print markdown_renderer.render(md_text)