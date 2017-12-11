defmodule Day8 do
  def solve_both(file_path) do
    maximum_tracker = spawn(fn -> keep_track_of_maximum(0) end)
    answer = File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> Enum.map(&(Regex.named_captures(~r/^(?<reg>\w+) (?<op>(dec)|(inc)) (?<val>-?\d+) if (?<cr>\w+) (?<co>\W{1,2}) (?<cv>-?\d+)$/, &1)))
    |> List.foldl(%{max: 0}, &(evaluate_instruction(&1, &2, maximum_tracker)))
    |> Map.values()
    |> Enum.max()
    send(maximum_tracker, {:get_max, self()})
    receive do
      {max} -> {answer, max}
    end
  end

  defp evaluate_instruction(insts = %{}, regs, maximum_tracker) do
    new_reg = update_register(regs, insts["reg"], insts["op"], String.to_integer(insts["val"]), evaluate_condition(Map.get(regs, insts["cr"], 0), insts["co"], String.to_integer(insts["cv"])))
    new_max = Map.values(new_reg) |> Enum.max()
    send(maximum_tracker, {:current_max, new_max})
    new_reg
  end
  
  defp update_register(regs, reg, "inc", val, true) do
    Map.update(regs, reg, 0 + val, &(&1 + val))
  end

  defp update_register(regs, reg, "dec", val, true) do
    Map.update(regs, reg, 0 - val, &(&1 - val))
  end

  defp update_register(regs, _, _, _, false), do: regs

  defp evaluate_condition(cr, ">", cv), do: cr > cv
  defp evaluate_condition(cr, "<", cv), do: cr < cv
  defp evaluate_condition(cr, ">=", cv), do: cr >= cv
  defp evaluate_condition(cr, "<=", cv), do: cr <= cv
  defp evaluate_condition(cr, "!=", cv), do: cr != cv
  defp evaluate_condition(cr, "==", cv), do: cr == cv

  def keep_track_of_maximum(maximum) do
    receive do
      {:current_max, max} when max > maximum ->
        keep_track_of_maximum(max)
      {:current_max, _} ->
        keep_track_of_maximum(maximum)
      {:get_max, caller} ->
        send(caller, {maximum})
    end
  end
end

{part1, part2} = Day8.solve_both("input")
IO.puts "Part 1: #{part1}, Part 2: #{part2}"