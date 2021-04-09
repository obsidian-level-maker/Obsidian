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
 * rng-alg-fst.h
 *
 * @version 3.0 (December 2000)
 *
 * Note: This is a Rijndael variant.
 *
 * @author Vincent Rijmen <vincent.rijmen@esat.kuleuven.ac.be>
 * @author Antoon Bosselaers <antoon.bosselaers@esat.kuleuven.ac.be>
 * @author Paulo Barreto <paulo.barreto@terra.com.br>
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
 */
#ifndef __RNG_ALG_FST_H
#define __RNG_ALG_FST_H

#define MAXKC	(256/32)
#define MAXKB	(256/8)
#define MAXNR	14

typedef unsigned char	u8;	
typedef unsigned short	u16;	
typedef unsigned int	u32;

int rngKeySetupEnc(u32 rk[/*4*(Nr + 1)*/], const u8 cipherKey[], int keyBits);
void rngEncrypt(const u32 rk[/*4*(Nr + 1)*/], int Nr, const u8 pt[16], u8 ct[16]);

#endif /* __RNG_ALG_FST_H */
