/* check_pattern_in_log.c
 *
 * $Id: check_pattern_in_log.c 3354 2009-11-05 00:21:00Z harrison $
 *
 * [bug:3036 check file content line by line against the pattern
 * either from either STDIN or text file, eg, check block info from
 * the maillog, etc]
 * 
 *
 * 
 *
 * Compile using gcc -o check_pattern_in_log check_pattern_in_log.c `pcre-config --libs`
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include <pcre.h>

void
preprocess_regex(char *regex, int *casesensitive)
{
	size_t lead = 0;
	char tempregex[4096];
	
	/* Crude check for modifiers -- assumes correct formatting and that they'll never appear in a regex. */
	if ( strstr(regex, "casesensitive") )
	{
		*casesensitive = 1;
	}
	/* Cut off the trailing newline */
	if( strrchr(regex, '\n') )
	{
		*strrchr(regex, '\n') = '\0';
	}
	
	/* Whack off the tail end of the regex -- all modifiers and comments */
	if( strchr(regex, '#') )
	{
		*strchr(regex, '#') = '\0';	
	}
        /* Trim leading and trailing whitespace */
	lead = strspn(regex, " \t");
	if( lead > 0 )
	{
		memmove(regex, regex + lead, strlen(regex) - lead + 1);
	}
	while(regex[strlen(regex) - 1] == ' ')
	{
		regex[strlen(regex) - 1] = '\0';
	}
	
	/* Add anchors */
	if( strlen(regex) > 0 )
	{
                sprintf(tempregex, "^%s$", regex);
                strcpy(regex, tempregex);
        }
}

void fixup_line(char *line)
{
	line[strlen(line) - 1] = '\0';	/* Cut off the trailing newline */
	while(strchr(line, '_'))
	{
		*strchr(line, '_') = ' ';
	}
}


int
main(int argc, char *argv[])
{
	int i;
	char line[1024];
	int ovector[300];
	FILE *infile;
	struct stat dummy;
	pcre *comp_regex;
	int result;
	int matches;
	int lines = 0;
	
	const char * errptr;
	int offset;
		
	/* Read the regexes in from stdin */
	while(!feof(stdin))
	{
		int casesensitive = 0;

                char regex[4096] = { };
		fgets(regex, 4096, stdin);
		/* For each regex */
		/* Preprocess */
		preprocess_regex(regex, &casesensitive);
		if(strlen(regex) > 0)
		{
                        
			matches = 0;
			fprintf(stderr, "Testing /%s/%c now\n", regex, casesensitive?' ':'i');
			comp_regex = pcre_compile(regex, PCRE_UTF8|(casesensitive?0:PCRE_CASELESS), &errptr, &offset, NULL);
			if(NULL == comp_regex)
			{
				fprintf(stderr, "Compile Regex failed: %d %s\n", offset, errptr);
			}
			else
			{
                                /* Test */
                                for(i = 1; i<argc; i++)
                                        {
                                                /* If it's a file */
						if(!stat(argv[i], &dummy))
						{
                                                        
							infile = fopen(argv[i], "r");
							while(!feof(infile))
							{
								lines += 1;
								fgets(line, 1024, infile);
								fixup_line(line);
								result = pcre_exec(comp_regex, NULL, line, strlen(line), 0, 0, ovector, 300);
								if(result >= 0)
								{
									printf("*%s\n", line);
									matches += 1;
								}
								else if(result == PCRE_ERROR_NOMATCH)
								{
                                                                        #ifdef DEBUG
									printf("* No match\n");
                                                                        #endif
								}
								else
								{
									fprintf(stderr, "Error: %d\n", result);
								}
								if((lines % 100000) == 0)
								{
									fprintf(stderr, "Lines: %d            \r", lines);
								}
							}
							fclose(infile);
						}
						else
						{ /* Not a file try stdin */
							lines += 1;
							/* Otherwise, test as a literal */
							result = pcre_exec(comp_regex, NULL, argv[i], strlen(argv[i]), 0, 0, ovector, 300);
							if(result >= 0)
							{
								matches += 1;
								printf("*%s\n", argv[i] );
							}
							else if(result == PCRE_ERROR_NOMATCH)
							{
                                                                #ifdef DEBUG
                                                                printf("* No match\n");
                                                                #endif
							}
							else
							{
								fprintf(stderr, "Error: %d\n", result);
							}
						}
					}
			}
			fprintf(stderr, "Matches: %d\n", matches);
		}
	}

        return 0;
        
}
