defmodule Day9 do
    def solve(file_path) do
      solution = solve_both(file_path)
      {solution.score, solution.count}
    end

    defp solve_both(file_path) do
      File.read!(file_path)
      |> String.graphemes()
      |> List.foldl(%{depth: 1, score: 0, count: 0, in_garbage: false, ignore_next: false}, &parse_symbol(&1, &2))
    end

    defp parse_symbol(_, state = %{ignore_next: true}),   do: Map.put(state, :ignore_next, false)
    defp parse_symbol("!", state),                        do: Map.put(state, :ignore_next, true)
    defp parse_symbol("<", state = %{in_garbage: false}), do: Map.put(state, :in_garbage, true)
    defp parse_symbol(">", state = %{in_garbage: true}),  do: Map.put(state, :in_garbage, false)
    defp parse_symbol("}", state = %{in_garbage: false}), do: Map.update!(state, :depth, &(&1 - 1))
    defp parse_symbol("{", state = %{in_garbage: false}), do: Map.update!(state, :depth, &(&1 + 1)) |> Map.update!(:score, &(&1 + state.depth))
    defp parse_symbol(_, state = %{in_garbage: true}),    do: Map.update!(state, :count, &(&1 + 1))
    defp parse_symbol(_, state),                          do: state
end

{part1, part2} = Day9.solve("input")
IO.puts "Part 1: #{part1}, Part 2: #{part2}"