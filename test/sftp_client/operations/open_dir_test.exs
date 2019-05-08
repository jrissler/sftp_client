defmodule SFTPClient.Operations.OpenDirTest do
  use ExUnit.Case, async: true

  import Mox

  alias SFTPClient.Adapter.SFTP.Mock, as: SFTPMock
  alias SFTPClient.Conn
  alias SFTPClient.Handle
  alias SFTPClient.OperationError
  alias SFTPClient.Operations.OpenDir

  setup :verify_on_exit!

  @conn %Conn{channel_pid: :channel_pid_stub}
  @path "my/remote/path"

  describe "open_dir/2" do
    test "success" do
      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path' ->
        {:ok, :handle_id_stub}
      end)

      assert OpenDir.open_dir(@conn, @path) ==
               {:ok, %Handle{conn: @conn, id: :handle_id_stub, path: @path}}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path' ->
        {:error, reason}
      end)

      assert OpenDir.open_dir(@conn, @path) ==
               {:error, %OperationError{reason: reason}}
    end
  end

  describe "open_dir!/2" do
    test "success" do
      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path' ->
        {:ok, :handle_id_stub}
      end)

      assert OpenDir.open_dir!(@conn, @path) ==
               %Handle{conn: @conn, id: :handle_id_stub, path: @path}
    end

    test "error" do
      reason = :enoent

      expect(SFTPMock, :opendir, fn :channel_pid_stub, 'my/remote/path' ->
        {:error, reason}
      end)

      assert_raise OperationError, "Operation failed: #{reason}", fn ->
        OpenDir.open_dir!(@conn, @path)
      end
    end
  end
end
