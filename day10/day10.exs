defmodule Day10 do
  use Bitwise

  def solve_first(file_path) do
    [first | [second | _]] = File.read!(file_path)
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.foldl({Enum.to_list(0..255), 0, 0}, &(reverse_sublist(&1, &2)))
    |> elem(0)
    first * second
  end

  def solve_second(file_path) do
    File.read!(file_path)
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(&input_to_ascii/1)
    |> Kernel.++([17, 31, 73, 47, 23])
    |> List.duplicate(64)
    |> List.flatten()
    |> List.foldl({Enum.to_list(0..255), 0, 0}, &(reverse_sublist(&1, &2)))
    |> elem(0)
    |> Enum.chunk(16)
    |> Enum.map(&(Enum.reduce(&1, fn(x, acc) -> x ^^^ acc end)))
    |> Enum.map(&(int_to_string_hex(&1)))
    |> Enum.join()
    |> String.downcase()
  end

  defp reverse_sublist(len, {hash, skip_size, position}) when length(hash) - position > len do
    {Enum.reverse_slice(hash, position, len), skip_size + 1, rem(position + len + skip_size, 256)}
  end

  defp reverse_sublist(len, {hash, skip_size, position}) do
    first_half = Enum.slice(hash, position, len)
    second_half = Enum.slice(hash, 0, len - length(first_half))
    rest = Enum.slice(hash, (len - length(first_half))..(position - 1))
    reversed = Enum.reverse(first_half ++ second_half)
    {new_tail, new_head} = Enum.split(reversed, length(first_half))
    {new_head ++ rest ++ new_tail, skip_size + 1, rem(position + len + skip_size, 256)}
  end

  defp input_to_ascii(","), do: 44
  defp input_to_ascii(int), do: String.to_integer(int) + 48

  defp int_to_string_hex(int) when int < 10, do: "0#{Integer.to_string(int, 16)}"
  defp int_to_string_hex(int),               do: Integer.to_string(int, 16)
end

IO.puts Day10.solve_first("input")
IO.puts Day10.solve_second("input")