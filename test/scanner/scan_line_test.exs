defmodule Earmark.Scanner.ScanLineTest do
  use ExUnit.Case

  alias Earmark.Scanner

  [ 
    { "", [%Scanner.EmptyLine{}] },
    { "alpha beta", [%Scanner.Text{content: "alpha beta"}] },
    { " alpha", [%Scanner.Text{content: " alpha"}] },
    { "   alpha", [%Scanner.Text{content: "   alpha"}] },

    # Leading Whitespace
    { "    alpha", [%Scanner.LeadingWS{count: 4},%Scanner.Text{content: "alpha"}] },
    { "     alpha", [%Scanner.LeadingWS{count: 5},%Scanner.Text{content: "alpha"}] },
    { "     # no headline", [%Scanner.LeadingWS{count: 5},%Scanner.Text{content: "# no headline"}] },

    # Rulers
    { "***", [%Scanner.Ruler{content: "***", type: "*"}] },
    { "_ ___ _", [%Scanner.Ruler{content: "_ ___ _", type: "_"}] },
    { "---", [%Scanner.Ruler{content: "---", type: "-"}] },
    { "_ _", [%Scanner.Text{content: "_ _"}] },
    { "**", [%Scanner.Text{content: "**"}] },

    # Headlines
    { "#", [%Scanner.Text{content: "#"}]},
    { " #", [%Scanner.Text{content: " #"}]},
    { "##", [%Scanner.Text{content: "##"}]},
    { "###xxx", [%Scanner.Text{content: "###xxx"}]},
    { "# ", [%Scanner.Headline{level: 1}]},
    { "###  ", [%Scanner.Headline{level: 3}]},
    { "###### Hello `World`", [
      %Scanner.Headline{level: 6},
      %Scanner.Text{content: "Hello "},
      %Scanner.Backtix{count: 1},
      %Scanner.Text{content: "World"},
      %Scanner.Backtix{count: 1}]},
    { "####   3 * 2", [%Scanner.Headline{level: 4},%Scanner.Text{content: "3 * 2"}]},
    { "####### text", [%Scanner.Text{content: "####### text"}]},
    { " # Hello", [%Scanner.Text{content: " # Hello"}]},

    # Backtix
    { "`", [%Scanner.Backtix{count: 1}]},
    { " `````a", [%Scanner.Text{content: " "},%Scanner.Backtix{count: 5},%Scanner.Text{content: "a"}]},
    { "     `````a", [%Scanner.LeadingWS{count: 5},%Scanner.Backtix{count: 5},%Scanner.Text{content: "a"}]},

  ]
  |> Enum.each(fn { text, tokens } -> 
    test("line: '" <> text <> "'") do
      assert Scanner.scan_line(unquote(text)) == unquote(Macro.escape(tokens))
    end
  end)
end
