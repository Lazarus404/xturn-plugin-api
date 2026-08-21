# XTurn Plugin API

The plugin contract for [xturn](https://github.com/Lazarus404/xturn) data-plane plugins:

- `Xirsys.XTurn.Plugin` — the behaviour a plugin implements (`mode/0`, `hooks/0`,
  `attach?/2`, `init/2`, `handle_frame/3`, plus optional `handle_close/2` and
  `handle_info/2`).
- `Xirsys.XTurn.Plugin.Allocation` — the per-allocation context passed to `attach?/2`
  and `init/2`.
- `Xirsys.XTurn.Plugin.Frame` — the per-frame metadata passed to `handle_frame/3`.

## Why this exists

XTurn implements and drives plugins; a plugin package (such as
[xturn-plugins](https://github.com/Lazarus404/xturn-plugins)) implements this contract and
therefore depends on XTurn's types.

## Usage

```elixir
defp deps do
  [
    {:xturn_plugin_api, "~> 0.1.0"}
  ]
end
```

Then implement the behaviour:

```elixir
defmodule MyApp.Plugin do
  @behaviour Xirsys.XTurn.Plugin

  @impl true
  def mode, do: :active

  @impl true
  def hooks, do: [:egress]

  @impl true
  def attach?(%Xirsys.XTurn.Plugin.Allocation{}, _opts), do: true

  @impl true
  def init(_allocation, _opts), do: {:ok, nil}

  @impl true
  def handle_frame(payload, %Xirsys.XTurn.Plugin.Frame{}, _state), do: {:ok, payload}
end
```
