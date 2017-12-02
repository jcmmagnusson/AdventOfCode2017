defmodule Day2 do

  def calculate_checksum(file_path) do
    parse_file(file_path)
    |> Enum.map(&checksum_row/1)
    |> Enum.sum()
  end

  def divide_thingey(file_path) do
    parse_file(file_path)
    |> Enum.map(&divide_row/1)
    |> Enum.sum()
  end

  defp parse_file(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn numbers -> Enum.map(numbers, &String.to_integer/1) end)
    |> List.delete_at(-1)
  end

  defp checksum_row(num_row) do
    Enum.max(num_row) - Enum.min(num_row)
  end

  defp divide_row([_ | []]), do: 0

  defp divide_row(num_row) do
    row_sum(num_row) + divide_row(tl(num_row))
  end

  defp row_sum([x | xs]) do
    xs
    |> Enum.map(fn num -> divide(x, num) end)
    |> Enum.sum()
  end

  defp divide(x, y) when rem(x, y) == 0, do: div(x, y)
  defp divide(x, y) when rem(y, x) == 0, do: div(y, x)
  defp divide(_, _),                     do: 0
end

IO.puts Day2.calculate_checksum("day2.txt") # Part 1
IO.puts Day2.divide_thingey("day2.txt")     # Part 2