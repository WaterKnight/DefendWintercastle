#include <stdio.h>

int main(int argc, char *argv[]){
    char argLine[1000] = "";
    int i;

    char loaderCmd[1000] = "";

    FILE *file = fopen("output.txt", "w+");

    printf("\n");

    //build argLine
/*    fprintf(file, argv[0]);
    fprintf(file, "\n");
        fprintf(file, argv[1]);
            fprintf(file, "\n");
            fprintf(file, argv[2]);
                        fprintf(file, "\n");
                fprintf(file, argv[3]);
                                        fprintf(file, "\n");
                                fprintf(file, argv[4]);
                                                        fprintf(file, "\n");
                                                        fprintf(file, "%i", argc);
fclose(file);
                system("pause");*/
    for (i=1;i<argc;i++){
        printf("\nargument %i: %s\n", i, argv[i]);
        fprintf(file, "\nargument %i: %s", i, argv[i]);

        if (strcmp(argv[i] + strlen(argv[i]) - 1, "\\") == 0){
            strcat(argLine, " \"");
            strcat(argLine, argv[i]);
            strcat(argLine, "\\\"");
        }
        else{
            strcat(argLine, " \"");
            strcat(argLine, argv[i]);
            strcat(argLine, "\"");
        }
    }

    //build cmds
    //strcat(loaderCmd, "lua jasshelper\\spellLoader\\luaproach.lua ");
    strcat(loaderCmd, "D:\\Warcraft III\\Mapping\\DWC\\compiler\\startFromExtern.bat ");

    strcat(loaderCmd, argLine);
    fprintf(file, "\n");
fprintf(file, loaderCmd);
remove("D:\\success.txt");

system(loaderCmd);

FILE *f = fopen("D:\\success.txt", "r");

if (!(f)){
    return;
}

fclose(f);

remove("D:\\success.txt");

    return 0;
}
