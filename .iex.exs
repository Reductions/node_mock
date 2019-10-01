gen = fn rounds ->
  for _ <- 1..rounds do
    NodeMock.Block.try_generate(0.1, 0.05)
  end
  |> Enum.filter(&is_binary/1)
  |> Enum.group_by(& &1)
  |> Enum.map(fn {x, y} -> {x, Enum.count(y)} end)
  |> Enum.into(%{})
end
