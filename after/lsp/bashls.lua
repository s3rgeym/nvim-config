return {
  settings = {
    bashIDE = {
      globPattern = "*@(.sh|.bash|.zsh)",
      shellcheckPath = "shellcheck",
      shfmt = {
        path = "shfmt",
        -- Отступы в 2 пробела и... if... else
        args = { "-i", "2", "-ci" },
      },
    },
  },
}
