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

#ifndef PYTHIA_PYTHIA_BUF_SIZES_H
#define PYTHIA_PYTHIA_BUF_SIZES_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/// Buffer size for bn_t instances
const extern size_t PYTHIA_BN_BUF_SIZE;

/// Buffer size for g1_t instances
const extern size_t PYTHIA_G1_BUF_SIZE;

/// Buffer size for g2_t instances
const extern size_t PYTHIA_G2_BUF_SIZE;

/// Buffer size for gt_t instances
const extern size_t PYTHIA_GT_BUF_SIZE;

/// Minimum binary arguments size (e.g. tweak, secrets)
const extern size_t PYTHIA_BIN_MIN_BUF_SIZE;

/// Maximum binary arguments size (e.g. tweak, secrets)
const extern size_t PYTHIA_BIN_MAX_BUF_SIZE;

#ifdef __cplusplus
}
#endif

#endif //PYTHIA_PYTHIA_BUF_SIZES_H
