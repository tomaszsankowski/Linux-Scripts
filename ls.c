#include <stddef.h>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pwd.h>
#include <grp.h>
#include <string.h>
#include <time.h>


#define DIRECTORY "/etc"


#ifdef HAVE_ST_BIRTHTIME
#define birthtime(x) x.st_birthtime
#else
#define birthtime(x) x.st_ctime
#endif

void lsprogram(const char* directoryPath) {
    DIR *pDIR;
    struct dirent *pDirEnt;

    pDIR = opendir(directoryPath);
    if (pDIR == NULL) {
    fprintf(stderr, "%s %d: opendir() failed (%s)\n", __FILE__, __LINE__, strerror(errno));
    exit(-1);
    }

    pDirEnt = readdir(pDIR);
while (pDirEnt != NULL) {
    if (strcmp(pDirEnt->d_name, ".") != 0 && strcmp(pDirEnt->d_name, "..") != 0) {
        struct stat fileStat;
        char fullPath[PATH_MAX];
        sprintf(fullPath, "%s/%s", directoryPath, pDirEnt->d_name);

        if (stat(fullPath, &fileStat) == 0) {
            if (S_ISDIR(fileStat.st_mode)) {
                printf("\n%s\n", fullPath);
                lsprogram(fullPath);
            }

            struct passwd *pw = getpwuid(fileStat.st_uid);
            struct group *gr = getgrgid(fileStat.st_gid);
            printf( (S_ISDIR(fileStat.st_mode)) ? "d" : "-");
            printf( (fileStat.st_mode & S_IRUSR) ? "r" : "-");
            printf( (fileStat.st_mode & S_IWUSR) ? "w" : "-");
            printf( (fileStat.st_mode & S_IXUSR) ? "x" : "-");
            printf( (fileStat.st_mode & S_IRGRP) ? "r" : "-");
            printf( (fileStat.st_mode & S_IWGRP) ? "w" : "-");
            printf( (fileStat.st_mode & S_IXGRP) ? "x" : "-");
            printf( (fileStat.st_mode & S_IROTH) ? "r" : "-");
            printf( (fileStat.st_mode & S_IWOTH) ? "w" : "-");
            printf( (fileStat.st_mode & S_IXOTH) ? "x" : "-");
            printf("\t%s\t%lld\t%s\t%s\t%s", pDirEnt->d_name, (long long)fileStat.st_size, pw->pw_name, gr->gr_name, ctime(&birthtime(fileStat)));
        }
    }
    pDirEnt = readdir(pDIR);
}


closedir(pDIR);
}

int main(int argc, char *argv[]) {
lsprogram(DIRECTORY);
return 0;
}
