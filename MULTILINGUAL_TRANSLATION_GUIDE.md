# Multilingual Translation System for Heather Bot

## Overview
The bot now supports 5 languages: **English (en), French (fr), Spanish (es), German (de), Japanese (ja)**

Users can set their language preference with `/lang` command, and all supported messages will be displayed in their chosen language.

## How It Works

### 1. Language Preferences Storage
- User language preferences are stored in `/data/language_preferences.json`
- Format: `{user_id: language_code}`
- Example: `{"123456": "fr", "789012": "es"}`

### 2. Core Functions

#### `get_user_language(chat_id: int) -> str`
- Returns user's language preference or defaults to 'en'
- Automatically loads from language_preferences.json

#### `set_user_language(chat_id: int, language: str)`
- Sets user's language preference
- Validates language against available translations
- Persists to language_preferences.json

#### `translate(key: str, chat_id: int, **kwargs) -> str`
- Central translation function used throughout bot
- Supports format placeholders: `{name}`, `{id}`, `{lang}`, etc.
- Fallback: Returns English if language translation missing
- Example: `translate('user_blocked', chat_id, id=12345, name='John')`

### 3. Translation Dictionary (TRANSLATIONS)

Located in heather_telegram_bot.py, contains keys for:

**User Commands:**
- `help_user_intro`, `help_user_features`, `help_user_commands` - /help display
- `reset_message` - /reset confirmation
- `voice_not_working`, `voice_on_response`, `voice_off_response` - /voice_on/off messages
- `status_info` - /status display

**Admin Commands:**
- `cannot_block_admin`, `user_blocked`, `user_not_blocked`, `user_unblocked` - User blocking
- `admin_reset_user` - user state reset
- `admin_reload_complete` - personality reload
- `personality_reloaded`, `personality_reload_failed` - reload results
- `stories_loading`, `story_list`, `no_stories` - story bank display
- `videos_refreshed` - video refresh confirmation

**System:** 
- `lang_set`, `unknown_language` - language preference
- `manual_mode_on`, `manual_mode_off` - manual mode toggle
- `redteam_enabled`, `redteam_disabled` - guardrail bypass status

## Adding New Translations

### Step 1: Add to TRANSLATIONS Dictionary
```python
TRANSLATIONS = {
    'my_new_message': {
        'en': "English version here",
        'fr': "Version française ici",
        'es': "Versión en español aquí",
        'de': "Deutsche Version hier",
        'ja': "日本語版はここにあります",
    },
}
```

### Step 2: Use in Code
```python
msg = translate('my_new_message', chat_id)
await event.respond(msg)

# With parameters
msg = translate('user_blocked', chat_id, id=user_id, name=user_name)
```

## Testing Translations

1. **Set Language:**
   ```
   /lang fr  # Switch to French
   /lang es  # Switch to Spanish
   /lang de  # Switch to German
   /lang ja  # Switch to Japanese
   /lang en  # Reset to English
   ```

2. **View Language:**
   ```
   /lang  # Shows current language and options
   ```

3. **Test Translated Commands:**
   ```
   /about        # Should display in chosen language
   /help         # User help in chosen language
   /reset        # Confirmation in chosen language
   /voice_on     # Voice mode message in language
   ```

## Currently Translated Commands

### User-Facing (High Priority)
- ✅ `/about` - AI disclosure in 5 languages
- ✅ `/help` - Command help in 5 languages
- ✅ `/reset` - Conversation reset in 5 languages
- ✅ `/voice_on` / `/voice_off` - Voice toggle in 5 languages
- ✅ `/lang` - Language preference UI in 5 languages

### Admin Commands (Translated)
- ✅ `/admin_block` - User blocking messages
- ✅ `/admin_unblock` - User unblocking messages
- ✅ `/admin_reset` - User state reset
- ✅ `/admin_reload` - Personality reload results
- ✅ `/manual_on` / `/manual_off` - Manual mode toggle

### Partially Supported
- `/admin_stats` - Complex display (awaiting extended translation)
- `/redteam_on` / `/redteam_off` - Complex messages (awaiting adaptation)
- `/admin_flags` - CSAM review (awaiting translation)
- `/admin_reengage_*` - Re-engagement (awaiting translation)

## Language Persistence

- Language preference persists across bot restarts
- Each user has independent language setting
- Default language is English for new users
- Language data stored in separate JSON file (not in tip_history.json)

## Error Handling

If a translation key is missing:
- Falls back to English version
- Logs warning: `"[Missing translation: key_name]"`
- Returns placeholder text for safety

If language preference is corrupted:
- Defaults to English
- Logs error with details
- Resets user to 'en'

## Future Expansion

To add more languages:
1. Add language code to patterns: `/lang(?:\s+(en|fr|es|de|ja|new_lang))?`
2. Add translations for all TRANSLATIONS dictionary keys
3. Update `/help` and `/lang` UI to list new language
4. Update ABOUT_TRANSLATIONS for new language

Example: Adding Italian (it)
```python
'help_user_intro': {
    'en': "...",
    'fr': "...",
    'it': "Ciao babe, parlami 😂 Ma ecco cosa posso fare:",  # Italian
}
```

## File References

- **Main Bot:** `/heather/heather_telegram_bot.py`
  - Lines ~7200-7300: ABOUT_TRANSLATIONS dict
  - Lines ~7310-7400: TRANSLATIONS dict  
  - Lines ~7400-7450: translate() function
  - Lines ~1100-1150: Language preference functions (load/save/get/set)

- **Data File:** `/data/language_preferences.json`
  - User language preferences storage
  - Created automatically on first use
  - Manually editable JSON format

## Example Usage in Code

```python
# Simple translation
await event.respond(translate('voice_on_response', chat_id))

# Translation with parameters
msg = translate('user_blocked', chat_id, id=target_id, name=user_name)
await event.respond(msg)

# Get user's preferred language
lang = get_user_language(chat_id)
current = {'en': 'English', 'fr': 'Français', ...}.get(lang, lang)
```

## Troubleshooting

**Q: User's language setting not persisting**
- Check `/data/language_preferences.json` exists and is readable
- Verify JSON format is valid
- Check file permissions

**Q: Translations showing "[Missing translation: key]"**
- Verify translation key exists in TRANSLATIONS dict
- Check language code is in: en, fr, es, de, ja
- Add missing key to TRANSLATIONS with all 5 languages

**Q: Bot crashes on language switching**
- Verify all language keys in ABOUT_TRANSLATIONS and TRANSLATIONS
- Check translate() function error handling
- Review logs for specific error

## Contributors & Changes

- Initial system: English-only bot
- v2.0: Added dictionary-based admin system
- v3.0: Multi-language support (current)
  - Added ABOUT_TRANSLATIONS with 5 languages
  - Added TRANSLATIONS dictionary for system messages
  - Created translate() and language preference functions
  - Refactored key commands to use translate()

