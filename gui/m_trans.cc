//----------------------------------------------------------------------
//  TRANSLATION / INTERNATIONALIZATION
//----------------------------------------------------------------------
//
//  Oblige Level Maker
//
//  Copyright (C)      2016 Andrew Apted
//  Copyright (C) 1995-2015 Free Software Foundation, Inc.
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//----------------------------------------------------------------------
//
//  Note : we use some code from GNU Gettext (intl/localname.c)
//
//----------------------------------------------------------------------

#include "headers.h"
#include "hdr_lua.h"

#include "lib_util.h"

#include "main.h"
#include "m_trans.h"

#ifndef WIN32
#include <locale.h>
#endif


// current language
const char * t_language = "AUTO";


/* DETERMINE CURRENT LANGUAGE */

static const char * Trans_GetUserLanguage()
{
#ifdef WIN32

    /* Dispatch on language.
       See also http://www.unicode.org/unicode/onlinedat/languages.html .
       For details about languages, see http://www.ethnologue.com/ .  */

	int primary, sub;

	// andrewj: special check for traditional Chinese characters
	if (primary == LANG_CHINESE &&
		(sub == 0x1f ||
		 sub == SUBLANG_CHINESE_TRADITIONAL ||
		 sub == SUBLANG_CHINESE_HONGKONG ||
		 sub == SUBLANG_CHINESE_MACAU))
	{
		return "zh_TW";
	}

	switch (primary)
	{
		case LANG_AFRIKAANS:    return "af";
		case LANG_ALBANIAN:     return "sq";
		case LANG_ALSATIAN:     return "gsw";
		case LANG_AMHARIC:      return "am";
		case LANG_ARABIC:       return "ar";
		case LANG_ARMENIAN:     return "hy";
		case LANG_ASSAMESE:     return "as";
		case LANG_AZERI:        return "az";
		case LANG_BASHKIR:      return "ba";
		case LANG_BASQUE:       return "eu";
		case LANG_BELARUSIAN:   return "be";
		case LANG_BENGALI:      return "bn";
		case LANG_BRETON:       return "br";
		case LANG_BULGARIAN:    return "bg";
		case LANG_BURMESE:      return "my";
		case LANG_CAMBODIAN:    return "km";
		case LANG_CATALAN:      return "ca";
		case LANG_CHEROKEE:     return "chr";
		case LANG_CHINESE:      return "zh";
		case LANG_CORSICAN:     return "co";
		case LANG_CROATIAN:     return "hr";
		case LANG_CZECH:        return "cs";
		case LANG_DANISH:       return "da";
		case LANG_DARI:         return "prs";
		case LANG_DIVEHI:       return "dv";
		case LANG_DUTCH:        return "nl";
		case LANG_EDO:          return "bin";
		case LANG_ENGLISH:      return "en";
		case LANG_ESTONIAN:     return "et";
		case LANG_FAEROESE:     return "fo";
		case LANG_FARSI:        return "fa";
		case LANG_FINNISH:      return "fi";
		case LANG_FRENCH:       return "fr";
		case LANG_FRISIAN:      return "fy";
		case LANG_FULFULDE:     return "ff";
		case LANG_GAELIC:       return "ga";
		case LANG_GALICIAN:     return "gl";
		case LANG_GEORGIAN:     return "ka";
		case LANG_GERMAN:       return "de";
		case LANG_GREEK:        return "el";
		case LANG_GREENLANDIC:  return "kl";
		case LANG_GUARANI:      return "gn";
		case LANG_GUJARATI:     return "gu";
		case LANG_HAUSA:        return "ha";
		case LANG_HAWAIIAN:     return "haw";
		case LANG_HEBREW:       return "he";
		case LANG_HINDI:        return "hi";
		case LANG_HUNGARIAN:    return "hu";
		case LANG_IBIBIO:       return "nic";
		case LANG_ICELANDIC:    return "is";
		case LANG_IGBO:         return "ig";
		case LANG_INDONESIAN:   return "id";
		case LANG_INUKTITUT:    return "iu";
		case LANG_ITALIAN:      return "it";
		case LANG_JAPANESE:     return "ja";
		case LANG_KANNADA:      return "kn";
		case LANG_KANURI:       return "kr";
		case LANG_KASHMIRI:     return "ks";
		case LANG_KAZAK:        return "kk";
		case LANG_KICHE:        return "qut";
		case LANG_KINYARWANDA:  return "rw";
		case LANG_KONKANI:      return "kok";
		case LANG_KOREAN:       return "ko";
		case LANG_KYRGYZ:       return "ky";
		case LANG_LAO:          return "lo";
		case LANG_LATIN:        return "la";
		case LANG_LATVIAN:      return "lv";
		case LANG_LITHUANIAN:   return "lt";
		case LANG_LUXEMBOURGISH:  return "lb";
		case LANG_MACEDONIAN:   return "mk";
		case LANG_MALAY:        return "ms";
		case LANG_MALAYALAM:    return "ml";
		case LANG_MALTESE:      return "mt";
		case LANG_MANIPURI:     return "mni";
		case LANG_MAORI:        return "mi";
		case LANG_MAPUDUNGUN:   return "arn";
		case LANG_MARATHI:      return "mr";
		case LANG_MOHAWK:       return "moh";
		case LANG_MONGOLIAN:    return "mn";
		case LANG_NEPALI:       return "ne";
		case LANG_NORWEGIAN:    return "no";
		case LANG_OCCITAN:      return "oc";
		case LANG_ORIYA:        return "or";
		case LANG_OROMO:        return "om";
		case LANG_PAPIAMENTU:   return "pap";
		case LANG_PASHTO:       return "ps";
		case LANG_POLISH:       return "pl";
		case LANG_PORTUGUESE:   return "pt";
		case LANG_PUNJABI:      return "pa";
		case LANG_QUECHUA:      return "qu";
		case LANG_ROMANIAN:     return "ro";
		case LANG_ROMANSH:      return "rm";
		case LANG_RUSSIAN:      return "ru";
		case LANG_SAMI:         return "se";
		case LANG_SANSKRIT:     return "sa";
		case LANG_SCOTTISH_GAELIC:  return "gd";
		case LANG_SINDHI:       return "sd";
		case LANG_SINHALESE:    return "si";
		case LANG_SLOVAK:       return "sk";
		case LANG_SLOVENIAN:    return "sl";
		case LANG_SOMALI:       return "so";
		case LANG_SORBIAN:      return "wen";
		case LANG_SOTHO:        return "nso";
		case LANG_SPANISH:      return "es";
		case LANG_SUTU:         return "bnt";
		case LANG_SWAHILI:      return "sw";
		case LANG_SWEDISH:      return "sv";
		case LANG_SYRIAC:       return "syr";
		case LANG_TAGALOG:      return "tl";
		case LANG_TAJIK:        return "tg";
		case LANG_TAMAZIGHT:    return "ber";
		case LANG_TAMIL:        return "ta";
		case LANG_TATAR:        return "tt";
		case LANG_TELUGU:       return "te";
		case LANG_THAI:         return "th";
		case LANG_TIBETAN:      return "bo";
		case LANG_TIGRINYA:     return "ti";
		case LANG_TSONGA:       return "ts";
		case LANG_TSWANA:       return "tn";
		case LANG_TURKISH:      return "tr";
		case LANG_TURKMEN:      return "tk";
		case LANG_UIGHUR:       return "ug";
		case LANG_UKRAINIAN:    return "uk";
		case LANG_URDU:         return "ur";
		case LANG_UZBEK:        return "uz";
		case LANG_VENDA:        return "ve";
		case LANG_VIETNAMESE:   return "vi";
		case LANG_WELSH:        return "cy";
		case LANG_WOLOF:        return "wo";
		case LANG_XHOSA:        return "xh";
		case LANG_YAKUT:        return "sah";
		case LANG_YI:           return "ii";
		case LANG_YIDDISH:      return "yi";
		case LANG_YORUBA:       return "yo";
		case LANG_ZULU:         return "zu";

		default: return NULL;  // unknown
	}

#else  // Unix

	// FIXME

#endif
}


//----------------------------------------------------------------------


// TODO : stuff to parse PO files


//----------------------------------------------------------------------


typedef struct
{
	const char *langcode;
	const char *fullname;

} available_language_t;


static std::vector<available_language_t> available_langs;


void Trans_ParseLangLine(char *line)
{
	char *pos;

	// skip any BOM (may occur at very start of file)
	if ((u8_t)(line[0]) == 0xEF &&
		(u8_t)(line[1]) == 0xBB &&
		(u8_t)(line[2]) == 0xBF)
	{
		line += 3;
	}

	// remove CR/LF line ending
	pos = (char *)strchr(line, '\r');
	if (pos) pos[0] = 0;

	pos = (char *)strchr(line, '\n');
	if (pos) pos[0] = 0;

	// ignore blank lines and comments
	if (line[0] == 0 || line[0] == '#')
		return;

	// find separator
	pos = (char *)strchr(line, '=');

	if (! pos)
		return;  // uh oh

	*pos++ = 0;

	if (strlen(line) < 2 || strlen(pos) < 2)
		return;	 // uh oh

	// Ok, add the language

	available_language_t lang;

	lang.langcode = StringDup(line);
	lang.fullname = StringDup(pos);

//DEBUG
//  LogPrintf("  '%s' --> '%s'\n", lang.langcode, lang.fullname);

	available_langs.push_back(lang);
}


void Trans_Init()
{
#ifndef WIN32
	setlocale(LC_ALL, "");
#endif

	// TODO : stuff to create a Lua state to store messages in

	/* read the list of languages */

	char *path = StringPrintf("%s/language/LANGS.txt", install_dir);

	FILE *fp = fopen(path, "rb");

	if (! fp)
	{
		LogPrintf("WARNING: missing language/LANGS.txt file\n");
		return;
	}

	LogPrintf("Loading language list: %s\n", path);

	// simple line-by-line parser
	char buffer[MSG_BUF_LEN];

	while (fgets(buffer, MSG_BUF_LEN-2, fp))
	{
		Trans_ParseLangLine(buffer);
	}

	LogPrintf("DONE.\n\n");

	fclose(fp);
}


void Trans_SetLanguage(const char *langcode)
{
	// TODO
}


const char * Trans_GetAvailCode(int idx)
{
	SYS_ASSERT(idx >= 0);

	// end of list?
	if (idx >= (int)available_langs.size())
		return NULL;

	return available_langs[idx].langcode;
}


const char * Trans_GetAvailLanguage(int idx)
{
	SYS_ASSERT(idx >= 0);

	// end of list?
	if (idx >= (int)available_langs.size())
		return NULL;

	return available_langs[idx].fullname;
}


//----------------------------------------------------------------------


const char * ob_gettext(const char *s)
{
	return s;
}


//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
