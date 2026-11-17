request = File.read!("/request.json") |> JSON.decode!()
# No Mix project evaluation and no consumer application startup in this process.
Pudding.Project.Inspection.collect(request, "/work/build", "/scratch/export")

# Fixed-size export prevents an artifact flood from reaching host storage.
limit = 90_000_000

objects =
  "/scratch/export"
  |> Pudding.Project.Inputs.inventory()
  |> Enum.filter(fn {_name, entry} -> entry["type"] == "regular" end)
  |> Enum.sort()
  |> Enum.reduce({%{}, 0}, fn {name, entry}, {files, size} ->
    if size + entry["size"] > limit, do: raise("artifact output limit exceeded")
    bytes = File.read!(Path.join("/scratch/export", name))
    {Map.put(files, name, Base.encode64(bytes)), size + byte_size(bytes)}
  end)
  |> elem(0)

File.write!("/export/export.json", JSON.encode!(objects))
IO.puts("CAPTURE_INSPECTION_FINISHED closure_gate=blocked_supported_lynx_api_required")
