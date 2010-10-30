#ifndef LOGG_H
#define LOGG_H

#if defined(USE_ALLEGRO) && defined(HAVE_OGG)

#ifdef __cplusplus
extern "C" {
#endif

#include <allegro.h>
#include <vorbis/vorbisfile.h>

#define OGG_PAGES_TO_BUFFER 2

struct LOGG_Stream {
	char *buf[OGG_PAGES_TO_BUFFER];
	int current_page;
	int playing_page;
	AUDIOSTREAM* audio_stream;
	OggVorbis_File ovf;
	int bits;
	int stereo;
	int freq;
	int len;
	char* filename;
	int loop;
	int volume;
	int pan;
};

extern SAMPLE* logg_load(const char* filename);
extern int logg_get_buffer_size();
extern void logg_set_buffer_size(int size);
extern struct LOGG_Stream* logg_get_stream(const char* filename,
		int volume, int pan, int loop);
extern int logg_update_stream(struct LOGG_Stream* s);
extern void logg_destroy_stream(struct LOGG_Stream* s);
extern void logg_stop_stream(struct LOGG_Stream* s);
extern int logg_restart_stream(struct LOGG_Stream* s);

#ifdef __cplusplus
}
#endif

#endif // USE_ALLEGRO

#endif

