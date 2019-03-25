defmodule FaktoryWorker.PushPipelineTest do
  use ExUnit.Case

  describe "child_spec/1" do
    test "should return a default child_spec" do
      opts = [name: FaktoryWorker]
      child_spec = FaktoryWorker.PushPipeline.child_spec(opts)

      assert child_spec == default_child_spec()
    end

    test "should allow a custom name to be specified" do
      opts = [
        name: :my_test_faktory
      ]

      child_spec = FaktoryWorker.PushPipeline.child_spec(opts)
      config = get_child_spec_config(child_spec)

      assert config[:name] == :my_test_faktory
    end

    test "should allow pool config to be specified" do
      opts = [
        name: FaktoryWorker,
        pool: [
          size: 25
        ]
      ]

      child_spec = FaktoryWorker.PushPipeline.child_spec(opts)
      config = get_child_spec_config(child_spec)

      assert config[:pool][:size] == 25
    end
  end

  describe "start_link/1" do
    test "should start the pipeline" do
      opts = [name: FaktoryWorker]
      pid = start_supervised!(FaktoryWorker.PushPipeline.child_spec(opts))

      assert pid == Process.whereis(FaktoryWorker_pipeline)

      :ok = stop_supervised(FaktoryWorker.PushPipeline)
    end
  end

  defp default_child_spec() do
    %{
      id: FaktoryWorker.PushPipeline,
      start: {FaktoryWorker.PushPipeline, :start_link, [[name: FaktoryWorker]]},
      type: :supervisor
    }
  end

  defp get_child_spec_config(child_spec) do
    %{
      id: FaktoryWorker.PushPipeline,
      start: {FaktoryWorker.PushPipeline, :start_link, [config]},
      type: :supervisor
    } = child_spec

    config
  end
end
