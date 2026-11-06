# Don't print a new line at the start of the prompt
add_newline = false
# Pipes ╰─ ╭─
# Powerline symbols                                     
# Wedges 🭧🭒 🭣🭧🭓
# Random noise 🬖🬥🬔🬗
# Cool stuff 󰜥   

# format = """
# $directory $fill $git_branch $cmd_duration
#  $character"""
format = """
$cmd_duration $directory$git_branch
  $character"""

[fill]
symbol = '-'
style = 'fg:#7c6f64'

# Replace the "❯" symbol in the prompt with "➜"
[character]                            # The name of the module we are configuring is "character"
success_symbol = "[ ](bold fg:ACCENT)"
error_symbol = "[ ](bold fg:ERROR)"

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

[git_branch]
style = "bg: ACCENT"
symbol = "󰘬"
truncation_length = 12
truncation_symbol = ""
format = " 󰜥 [](bold fg:ACCENT)[$symbol $branch(:$remote_branch)](fg:ACCENT_FG bg:ACCENT)[ ](bold fg:ACCENT)"

[git_commit]
commit_hash_length = 4
tag_symbol = " "

[git_state]
format = '[\($state( $progress_current of $progress_total)\)]($style) '
cherry_pick = "[🍒 PICKING](bold red)"

[git_status]
conflicted = " 🏳 "
ahead = " 🏎💨 "
behind = " 😰 "
diverged = " 😵 "
untracked = " 🤷 ‍"
stashed = " 📦 "
modified = " 📝 "
staged = '[++\($count\)](green)'
renamed = " ✍️ "
deleted = " 🗑 "

[hostname]
ssh_only = false
format =  "[•$hostname](bg:ACCENT bold fg:ACCENT_FG)[](bold fg:ACCENT)"
trim_at = ".companyname.com"
disabled = false

[line_break]
disabled = false

[memory_usage]
disabled = true
threshold = -1
symbol = " "
style = "bold dimmed green"

[time]
disabled = true
format = '🕙[\[ $time \]]($style) '
time_format = "%T"

[username]
style_user = "bold bg:ACCENT fg:ACCENT_FG"
style_root = "red bold"
format = "[](bold fg:ACCENT)[$user]($style)"
disabled = false
show_always = true

[directory]
home_symbol = " "
read_only = "  "
style = "bg:DIR_BG fg:DIR_FG"
truncation_length = 2
truncation_symbol = ".../"
format = '[](bold fg:DIR_BG)[󰉋 → $path]($style)[](bold fg:DIR_BG)'


[directory.substitutions]
"Desktop" = "  "
"Documents" = "  "
"Downloads" = "  "
"Music" = " 󰎈 "
"Pictures" = "  "
"Videos" = "  "
"GitHub" = " 󰊤 "

[cmd_duration]
min_time = 0
format = '[](bold fg:ACCENT)[󰪢 $duration](bold bg:ACCENT fg:ACCENT_FG)[](bold fg:ACCENT)'
