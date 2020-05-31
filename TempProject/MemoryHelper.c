//
//  MemoryHelper.c
//  TempProject
//
//  Created by Scott Leonard on 5/31/20.
//  Copyright © 2020 DuhMarket. All rights reserved.
//

#include "MemoryHelper.h"

/// Method converts incoming object into an int and checks whether it is 0 or not. 0 == undefined value...
bool memoryChecker(void *address) {
	int *ptrValue = (int*) address;
	return *ptrValue;
}
