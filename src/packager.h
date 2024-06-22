#pragma once

#include <dirent.h>
#include <stdio.h>

extern void initRuntime();
extern int parse_args(int argc, char **argv);
extern int parse_metadata();
extern void writeModel(DIR *root, char *rootName);
extern void printMetadata(FILE *inputPackage);
