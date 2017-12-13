defmodule Day12 do
  # BEWARE! Awful code ahead, proceed with caution.

  def solve(file_path) do
    nsa = spawn(fn -> nsa(%{}) end)
    File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> List.foldl(%{}, &(create_graph(&1, &2)))
    |> search("0", nsa)
    :timer.sleep(100)
    send(nsa, {:get_count, self()})
    receive do
      count ->
        count
    end
  end

  def solve_second(file_path) do
    File.read!(file_path)
    |> String.split("\n")
    |> List.delete_at(-1)
    |> List.foldl(%{}, &(create_graph(&1, &2)))
    |> count_groups(0)
  end

  defp count_groups(graph, count) when graph == %{}, do: count

  defp count_groups(graph, count) do
    nsa = spawn(fn -> nsa(%{}) end)
    IO.inspect(count)
    search(graph, Enum.at(graph, 0)  |> elem(0), nsa)
    :timer.sleep(100)
    send(nsa, {:get_visited, self()})
    receive do
      visited ->
        count_groups(Map.drop(graph, Map.keys(visited)), count + 1)
    end
  end

  defp create_graph(input, graph) do
    parsed = Regex.named_captures(~r/(?<p>\d+) <-> (?<pipes>\d+(, \d+)*)/, input)
    pipes = parsed["pipes"] |> String.split(", ")
    Map.put(graph, parsed["p"], pipes)
  end

  defp search(graph, p, nsa) do
    send(nsa, {:visit, p})
    send(nsa, {:get_unvisited, graph[p], self()})
    receive do
      unvisited ->
        Enum.each(unvisited, &(spawn(fn -> search(graph, &1, nsa) end)))
    end
  end

  defp nsa(visited) do
    receive do
      {:get_unvisited, ps, pid} ->
        send(pid, Enum.reject(ps, &(Map.get(visited, &1, false))))
        nsa(visited)
      {:visit, p} ->
        nsa(Map.put(visited, p, true))
      {:get_count, pid} ->
        send(pid, Enum.count(visited))
      {:get_visited, pid} ->
        send(pid, visited)
    end
  end
end

IO.puts Day12.solve("input")
IO.puts Day12.solve_second("input")