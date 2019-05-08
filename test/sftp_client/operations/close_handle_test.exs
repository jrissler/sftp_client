defmodule SFTPClient.Operations.CloseHandleTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.CloseHandle

  setup :verify_on_exit!

  @handle %Handle{
    conn: %Conn{channel_pid: :channel_pid_stub},
    id: :handle_id_stub
  }

  describe "close_handle/1" do
    test "success" do
      expect(SFTPMock, :close, fn :channel_pid_stub, :handle_id_stub ->
        :ok
      end)

      assert CloseHandle.close_handle(@handle) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :close, fn :channel_pid_stub, :handle_id_stub ->
        {:error, reason}
      end)

      assert CloseHandle.close_handle(@handle) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "close_handle!/1" do
    test "success" do
      expect(SFTPMock, :close, fn :channel_pid_stub, :handle_id_stub ->
        :ok
      end)

      assert CloseHandle.close_handle!(@handle) == :ok
    end

    test "error" do
      reason = :error_stub

      expect(SFTPMock, :close, fn :channel_pid_stub, :handle_id_stub ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        CloseHandle.close_handle!(@handle)
      end
    end
  end
end
