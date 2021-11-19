/*
 * Copyright 2000 David Chess; Copyright 2005 Sam Trenholme
 *
 * Slump is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2, or (at your option) any later
 * version.
 *
 * Slump is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Slump; see the file GPL.  If not, write to the Free
 * Software Foundation, 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Additionally, while not required for redistribution of this program, 
 * the following requests are made when making a derived version of 
 * this program:
 * 
 * - Slump's code is partly derived from the Doom map generator 
 *   called SLIGE, by David Chess.  Please inform David Chess of 
 *   any derived version that you make.  His email address is at 
 *   the domain "theogeny.com" with the name "chess" placed before 
 *   the at symbol.
 *
 * - Please do not call any derivative of this program SLIGE.
 *
 */

/**
 * rng-api-fst.c
 *
 * @version 2.9 (December 2000)
 * (Modified by Sam for Slump use)
 *
 * Note: This is a Rijndael variant.
 *
 * @author Vincent Rijmen <vincent.rijmen@esat.kuleuven.ac.be>
 * @author Antoon Bosselaers <antoon.bosselaers@esat.kuleuven.ac.be>
 * @author Paulo Barreto <paulo.barreto@terra.com.br>
 * @author Sam Trenholme <list-subscribe@maradns.org>
 *
 * This code is hereby placed in the public domain.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHORS ''AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Acknowledgements:
 *
 * We are deeply indebted to the following people for their bug reports,
 * fixes, and improvement suggestions to this implementation. Though we
 * tried to list all contributions, we apologise in advance for any
 * missing reference.
 *
 * Andrew Bales <Andrew.Bales@Honeywell.com>
 * Markus Friedl <markus.friedl@informatik.uni-erlangen.de>
 * John Skodon <skodonj@webquill.com>
 */

#include <assert.h>
#include <stdlib.h>
#include <string.h>

#include "rng-alg-fst.h"
#include "rng-api-fst.h"

int makeKey(keyInstance *key, BYTE direction, int keyLen, char *keyMaterial) {
	int i;
	char *keyMat;
	u8 cipherKey[MAXKB];
	
	if (key == NULL) {
		return BAD_KEY_INSTANCE;
	}

	if (direction == DIR_ENCRYPT) {
		key->direction = direction;
	} else {
		return BAD_KEY_DIR;
	}

	if (keyLen == 128) {
		key->keyLen = keyLen;
	} else {
		return BAD_KEY_MAT;
	}

#ifdef ASCII_KEY
        strncpy(key->keyMaterial, keyMaterial, keyLen/4);
#else
        memcpy(key->keyMaterial, keyMaterial, keyLen/8);
#endif

	/* initialize key schedule: */
	keyMat = key->keyMaterial;
 	for (i = 0; i < key->keyLen/8; i++) {
		int v;
#ifdef ASCII_KEY
		int t;
		t = *keyMat++;
		if ((t >= '0') && (t <= '9')) v = (t - '0') << 4;
		else if ((t >= 'a') && (t <= 'f')) v = (t - 'a' + 10) << 4;
		else if ((t >= 'A') && (t <= 'F')) v = (t - 'A' + 10) << 4;
		else return BAD_KEY_MAT;
		
		t = *keyMat++;
		if ((t >= '0') && (t <= '9')) v ^= (t - '0');
		else if ((t >= 'a') && (t <= 'f')) v ^= (t - 'a' + 10);
		else if ((t >= 'A') && (t <= 'F')) v ^= (t - 'A' + 10);
		else return BAD_KEY_MAT;
#else
		v = *keyMat;
		keyMat++;
#endif /* ASCII_KEY */
		cipherKey[i] = (u8)v;
	}
	if (direction == DIR_ENCRYPT) {
		key->Nr = rngKeySetupEnc(key->rk, cipherKey, keyLen);
	} else {
		return -1;
	}
	rngKeySetupEnc(key->ek, cipherKey, keyLen);
	return TRUE;
}

int cipherInit(cipherInstance *cipher, BYTE mode, char *IV) {
	if (mode == MODE_ECB) {
		cipher->mode = mode;
	} else {
		return BAD_CIPHER_MODE;
	}
	if (IV != NULL) {
	        return BAD_CIPHER_MODE;
	} else {
		memset(cipher->IV, 0, MAX_IV_SIZE);
	}
	return TRUE;
}

int blockEncrypt(cipherInstance *cipher, keyInstance *key,
		BYTE *input, int inputLen, BYTE *outBuffer) {
	int i, numBlocks;

	if (cipher == NULL ||
		key == NULL ||
		key->direction == DIR_DECRYPT) {
		return BAD_CIPHER_STATE;
	}
	if (input == NULL || inputLen <= 0) {
		return 0; /* nothing to do */
	}

	numBlocks = inputLen/128;
	
	switch (cipher->mode) {
	case MODE_ECB:
		for (i = numBlocks; i > 0; i--) {
			rngEncrypt(key->rk, key->Nr, input, outBuffer);
			input += 16;
			outBuffer += 16;
		}
		break;
		
	default:
		return BAD_CIPHER_STATE;
	}
	
	return 128*numBlocks;
}

