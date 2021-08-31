/**
 * Copyright (C) 2015-2018 Virgil Security Inc.

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#ifndef PYTHIA_PYTHIA_BUF_H
#define PYTHIA_PYTHIA_BUF_H

#include <stdint.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Byte buffers used to pass data to/from pythia library
typedef struct pythia_buf {
    uint8_t *p;         /// Byte array pointer
    size_t allocated;   /// Number of allocated bytes
    size_t len;         /// Number of used bytes
} pythia_buf_t;

/// Creates new emoty pythia buffer (WARNING: Memory for actual byte array is not allocated here)
/// \return allocated empty pythia buffer
pythia_buf_t *pythia_buf_new(void);

/// Frees pythia buffer (WARNING: Doesn't free actual buffer memory, only memory needed for pythia_buf instance itself)
void pythia_buf_free(pythia_buf_t *buf);

/// Initializes pythia buffer with given values
/// \param buf pythia buffer to be initialized
/// \param p byte array pointer
/// \param allocated number of allocated bytes
/// \param len number of used bytes
void pythia_buf_setup(pythia_buf_t *buf, uint8_t *p, size_t allocated, size_t len);

#ifdef __cplusplus
}
#endif

#endif //PYTHIA_PYTHIA_BUF_H
