source = "/out/fixed/proof.ndjson"
dest = File.open!("/out/tampered.ndjson", [:write])

{_names, 1} =
  Enum.reduce(File.stream!(source), {%{0 => ""}, 0}, fn line, {names, count} ->
    record = :json.decode(line)

    names =
      case record do
        %{"in" => id, "str" => %{"pre" => pre, "str" => str}} ->
          Map.put(
            names,
            id,
            Enum.join(Enum.reject([Map.fetch!(names, pre), str], &(&1 == "")), ".")
          )

        %{"in" => id, "num" => %{"pre" => pre, "i" => i}} ->
          Map.put(names, id, "#{Map.fetch!(names, pre)}.#{i}")

        _ ->
          names
      end

    {record, count} =
      case record do
        %{"thm" => %{"name" => name} = thm} ->
          if names[name] == "Elixir.ArchivePath.Laws.laws.binary_contract/1" do
            {Map.put(record, "thm", Map.put(thm, "value", 0)), count + 1}
          else
            {record, count}
          end

        _ ->
          {record, count}
      end

    IO.binwrite(dest, [:json.encode(record), "\n"])
    {names, count}
  end)

File.close(dest)
