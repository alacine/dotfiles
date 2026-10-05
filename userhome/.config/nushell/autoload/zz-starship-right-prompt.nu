$env.config = ($env.config? | default {} | upsert render_right_prompt_on_last_line false)
