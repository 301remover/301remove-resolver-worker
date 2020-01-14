defmodule ResolverWorkerTest do
  use ExUnit.Case
  doctest ResolverWorker

  # Bit.ly Tests

  test "test bitly with twitter" do
    url = "bit.ly/b0003"
    full = {:reply, :ok, "http://twitter.com/HansKee/statuses/4863319359"}
    assert ResolverWorker.handle_call({:bitly, url}) == full
  end

  test "test bitly w/ trello" do
    short = "bit.ly/1eyOBPE"
    res = {:reply, :ok, "https://trello.com/"}
    assert ResolverWorker.handle_call({:bitly, short}) == res
  end

  test "test bitly w/ pentagram" do
    short = "bit.ly/b0004"
    response = {:reply, :ok, "http://www.pentagram.com/en/"}
    assert ResolverWorker.handle_call({:bitly, short}) == response
  end

  test "Test bit.ly with google" do
    short = "bit.ly/ze6poY"
    response = {:reply, :ok, "http://google.com/"}
    assert ResolverWorker.handle_call({:bitly, short}) == response
  end

  # TinyURL Tests

  test "Test tinyurl with youtube" do
    short = "https://tinyurl.com/2fcpre6"
    response = {:reply, :ok, "https://www.youtube.com/watch?v=dQw4w9WgXcQ"}
    assert ResolverWorker.handle_call({:tiny, short}) == response
  end
end
