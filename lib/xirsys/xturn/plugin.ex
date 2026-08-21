### ----------------------------------------------------------------------
###
### Copyright (c) 2013 - 2026 Jahred Love and Xirsys LLC <experts@xirsys.com>
###
### All rights reserved.
###
### Redistribution and use in source and binary forms, with or without modification,
### are permitted provided that the following conditions are met:
###
### * Redistributions of source code must retain the above copyright notice, this
### list of conditions and the following disclaimer.
### * Redistributions in binary form must reproduce the above copyright notice,
### this list of conditions and the following disclaimer in the documentation
### and/or other materials provided with the distribution.
### * Neither the name of the authors nor the names of its contributors
### may be used to endorse or promote products derived from this software
### without specific prior written permission.
###
### THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
### EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
### WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
### DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
### DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
### (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
### LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
### ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
### (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
### SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###
### ----------------------------------------------------------------------

defmodule Xirsys.XTurn.Plugin do
  @moduledoc """
  Behaviour for xturn data-plane plugins. See PLUGIN_ARCH.md (in the xturn repo).
  """

  @type direction :: :egress | :ingress
  @type framing :: :send_indication | :channel_data | :data_indication

  @doc "Fixed for the lifetime of the module."
  @callback mode() :: :active | :passive

  @doc "Which directions this plugin wants. Never called for others."
  @callback hooks() :: [direction()]

  @doc """
  Called once per allocation, at allocation time. Return false and no instance is
  created and nothing is added to this allocation's chain.
  """
  @callback attach?(Xirsys.XTurn.Plugin.Allocation.t(), keyword()) :: boolean()

  @doc """
  Called once per attached allocation. For :passive plugins this runs inside the
  instance process. Returning :ignore aborts attachment.
  """
  @callback init(Xirsys.XTurn.Plugin.Allocation.t(), keyword()) ::
              {:ok, state :: term()} | :ignore

  @doc """
  Per-frame callback.

  :active  -> must return {:ok, binary} | :drop | {:error, term}. `state` is the
              immutable value from init/2; mutable state must be kept by the plugin
              itself (its own ETS table or process), because this is called
              concurrently from many processes.
  :passive -> must return {:ok, new_state}. Runs in the instance process.
  """
  @callback handle_frame(payload :: binary(), Xirsys.XTurn.Plugin.Frame.t(), state :: term()) ::
              {:ok, binary()} | :drop | {:error, term()} | {:ok, new_state :: term()}

  @doc "Allocation teardown. Flush and close here. Passive only."
  @callback handle_close(reason :: term(), state :: term()) :: :ok

  @doc """
  Optional message handler for passive plugins.

  A passive plugin's `self()` **is** the instance process, so
  `Process.send_after(self(), ...)` from `init/2` or `handle_frame/3` is the
  supported way to schedule periodic work.
  """
  @callback handle_info(msg :: term(), state :: term()) :: {:ok, new_state :: term()}

  @optional_callbacks handle_close: 2, handle_info: 2
end
