defmodule Day4 do

  def count_valid_passphrases(file_path) do
    file_path
    |> get_valid_passphrases()
    |> length()
  end

  def count_valid_passphrases_no_anagrams(file_path) do
    file_path
    |> get_valid_passphrases()
    |> Enum.filter(&is_valid_passphrase_no_anagrams/1)
    |> length()
  end

  defp get_valid_passphrases(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> Enum.filter(&is_valid_passphrase/1)
  end

  defp is_valid_passphrase(pass_phrase) do
    pass_phrase
    |> String.split()
    |> contains_no_duplicates(%{})
  end

  defp is_valid_passphrase_no_anagrams(pass_phrase) do
    pass_phrase
    |> String.split()
    |> contains_no_anagrams()
  end

  defp contains_no_duplicates([], _), do: true

  defp contains_no_duplicates([x | xs], checked) do
    not Map.get(checked, x, false) and contains_no_duplicates(xs, Map.put(checked, x, true))
  end

  defp contains_no_anagrams([]), do: true

  defp contains_no_anagrams([x | xs]) do
    List.foldl(xs, true, fn (w, acc) -> acc and not are_anagrams(w, x) end) and contains_no_anagrams(xs)
  end

  defp are_anagrams(w1, w2) do
    count_letters(w1) == count_letters(w2)
  end

  defp count_letters(word) do
    word
    |> String.graphemes()
    |> List.foldl(%{}, fn(x, acc) -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end
end

IO.puts Day4.count_valid_passphrases("input")
IO.puts Day4.count_valid_passphrases_no_anagrams("input")
