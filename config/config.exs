import Config

if Mix.env() != :prod do
  config :git_hooks,
    auto_install: true,
    verbose: true,
    hooks: [
      pre_commit: [
        tasks: [
          {:cmd, "mix format"},
          {:cmd, "mix dialyzer"}
        ]
      ],
      pre_push: [
        verbose: false,
        tasks: [
          {:cmd, "mix test"},
          {:cmd, "echo 'success!'"}
        ]
      ]
    ]
end
