defmodule Day1 do

  def calculate_captcha_1(file_path) do
    calculate_captcha(file_path)
    |> calculate
  end

  def calculate_captcha_2(file_path) do
    calculate_captcha(file_path)
    |> calculate_2
  end

  defp calculate_captcha(file_path) do
    File.read!(file_path)
    |> String.graphemes
    |> List.delete_at(-1)
    |> Enum.map(&String.to_integer/1)
  end

  defp calculate(num_list) do
    add_captcha(num_list, hd(num_list))
  end

  def calculate_2(num_list) do
    add_captcha_2(num_list ++ num_list, div((length num_list), 2))
  end

  defp add_captcha([x | xs], first_elem) when xs != [] do
    next(x, hd(xs)) + add_captcha(xs, first_elem)
  end

  defp add_captcha([x | _], first_elem) do
    next(x, first_elem)
  end

  defp add_captcha_2([x | xs], index) when (length xs) > index * 2 do
    next(x, Enum.at(xs, index - 1)) + add_captcha_2(xs, index)
  end

  defp add_captcha_2([x | xs], index) do
    next(x, Enum.at(xs, index - 1))
  end

  defp next(i, i), do: i
  defp next(i, j), do: 0

end

IO.puts Day1.calculate_captcha_1("input") # Part 1
IO.puts Day1.calculate_captcha_2("input") # Part 2
