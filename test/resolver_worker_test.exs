defmodule ResolverWorkerTest do
  use ExUnit.Case
  doctest ResolverWorker

  setup do
    resolver = start_supervised!(ResolverWorker)
    %{resolver: resolver}
  end

  test "bit.ly valid link 1" do
    shortcode = "b0003"
    response = {:ok, "http://twitter.com/HansKee/statuses/4863319359"}
    assert ResolverWorker.resolve("bit.ly", shortcode) == response
  end

  test "bit.ly valid link 2" do
    shortcode = "1eyOBPE"
    response = {:ok, "https://trello.com/"}
    assert ResolverWorker.resolve("bit.ly", shortcode) == response
  end

  test "bit.ly valid link 3" do
    shortcode = "b0004"
    response = {:ok, "http://www.pentagram.com/en/"}
    assert ResolverWorker.resolve("bit.ly", shortcode) == response
  end

  test "bit.ly valid link 4" do
    shortcode = "ze6poY"
    response = {:ok, "http://google.com/"}
    assert ResolverWorker.resolve("bit.ly", shortcode) == response
  end

  test "tinyurl.com valid link" do
    shortcode = "2fcpre6"
    response = {:ok, "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}
    assert ResolverWorker.resolve("tinyurl.com", shortcode) == response
  end

  test "goo.gl valid link" do
    shortcode = "2L1d"
    response = {:ok, "http://productiveblog.tumblr.com/"}
    assert ResolverWorker.resolve("goo.gl", shortcode) == response
  end
end
