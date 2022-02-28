defmodule Twetch do
  @moduledoc """
  Documentation for `Twetch`.
  """
  alias Twetch.{ABI, API, UTXO, Transaction}

  @doc """
  Publish Twetch post.
  """
  def publish(bot, action_name, args) do
    with {:ok, action} <- ABI.new(action_name, args),
         {:ok, %{invoice: invoice, payees: payees}} <- API.get_payees(bot, action),
         {:ok, updated_action} <- ABI.update(bot, action, invoice),
         {:ok, inputs} <- UTXO.build_inputs(bot),
         {:ok, tx} <- Transaction.build(bot, updated_action.args, inputs, payees),
         {:ok, txid} <- API.publish(bot, action_name, tx) do
      {:ok, txid}
    end
  end
end
