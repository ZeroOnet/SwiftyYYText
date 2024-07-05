//
//  c_bridge.c
//  SwiftyYYText
//
//  Created by 李文康 on 2024/7/5.
//

#include "c_bridge.h"

atomic_uint_fast64_t atomic_increment_one(atomic_uint_fast64_t *value) {
    atomic_fetch_add_explicit(value, 1, memory_order_relaxed);
    return atomic_load(value);
}
