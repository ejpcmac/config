import Config

config :mini_repo,
  port: String.to_integer(System.get_env("PORT", "4000")),
  url: System.get_env("MINI_REPO_URL", "http://localhost:4000")

store = {MiniRepo.Store.Local, root: System.get_env("MINI_REPO_STORE", "/data/Mirroirs/hex.pm")}

config :mini_repo,
  repositories: [
    hexpm_mirror: [
      store: store,
      upstream_name: "hexpm",
      upstream_url: "https://repo.hex.pm",

      # https://hex.pm/docs/public_keys
      upstream_public_key: """
      -----BEGIN PUBLIC KEY-----
      MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApqREcFDt5vV21JVe2QNB
      Edvzk6w36aNFhVGWN5toNJRjRJ6m4hIuG4KaXtDWVLjnvct6MYMfqhC79HAGwyF+
      IqR6Q6a5bbFSsImgBJwz1oadoVKD6ZNetAuCIK84cjMrEFRkELtEIPNHblCzUkkM
      3rS9+DPlnfG8hBvGi6tvQIuZmXGCxF/73hU0/MyGhbmEjIKRtG6b0sJYKelRLTPW
      XgK7s5pESgiwf2YC/2MGDXjAJfpfCd0RpLdvd4eRiXtVlE9qO9bND94E7PgQ/xqZ
      J1i2xWFndWa6nfFnRxZmCStCOZWYYPlaxr+FZceFbpMwzTNs4g3d4tLNUcbKAIH4
      0wIDAQAB
      -----END PUBLIC KEY-----
      """,

      # 10 min
      sync_interval: 10 * 60 * 1000,
      sync_opts: [timeout: :infinity]
    ]
  ]
