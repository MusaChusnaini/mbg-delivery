extends Node

# Referensi ke node AudioStreamPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

var music_folder_path: String
var playlist: Array[String] = []
var current_track_index: int = -1

func _ready():
	# Menentukan lokasi folder berdasarkan status eksekusi game
	if OS.has_feature("editor"):
		# Saat masih *development* di dalam Editor Godot, 
		# folder dibuat di dalam root proyek agar mudah di-test
		music_folder_path = ProjectSettings.globalize_path("res://CustomMusic")
	else:
		# Saat game sudah di-export (.exe, .bin, dll),
		# folder akan berada tepat di sebelah file eksekusi game tersebut
		music_folder_path = OS.get_executable_path().get_base_dir() + "/CustomMusic"
	
	ensure_music_folder_exists()
	scan_music_folder()
	
	# Hubungkan sinyal otomatis saat lagu selesai untuk memutar lagu berikutnya
	audio_player.finished.connect(_on_audio_player_finished)
	
	# Putar lagu pertama jika playlist tidak kosong
	if playlist.size() > 0:
		play_track(0)
	else:
		print("Playlist kosong. Masukkan file .mp3 atau .ogg ke: ", music_folder_path)

# Fungsi untuk memastikan folder CustomMusic otomatis terbuat jika belum ada
func ensure_music_folder_exists():
	var dir = DirAccess.open(OS.get_executable_path().get_base_dir())
	if dir and not DirAccess.dir_exists_absolute(music_folder_path):
		DirAccess.make_dir_absolute(music_folder_path)
		print("Folder CustomMusic berhasil dibuat di: ", music_folder_path)

# Fungsi untuk memindai isi folder dan memasukkan file audio ke dalam array
func scan_music_folder():
	playlist.clear()
	var dir = DirAccess.open(music_folder_path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				var ext = file_name.get_extension().to_lower()
				# Memfilter format audio yang didukung secara runtime
				if ext == "mp3" or ext == "ogg":
					playlist.append(music_folder_path + "/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	print("Playlist berhasil dimuat. Total lagu ditemukan: ", playlist.size())

# Fungsi untuk memuat file audio fisik dan mengubahnya menjadi AudioStream
func load_external_audio(path: String) -> AudioStream:
	var ext = path.get_extension().to_lower()
	
	if ext == "mp3":
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var stream = AudioStreamMP3.new()
			# Membaca data binary file mp3 dan memasukkannya ke stream data
			stream.data = file.get_buffer(file.get_length())
			return stream
			
	elif ext == "ogg":
		# Godot 4 memiliki fungsi static khusus untuk memuat file OGG eksternal dengan sangat mudah
		var stream = AudioStreamOggVorbis.load_from_file(path)
		if stream:
			return stream
			
	print("Gagal memuat format file atau file rusak: ", path)
	return null

# Fungsi utama untuk memutar lagu berdasarkan index playlist
func play_track(index: int):
	if index < 0 or index >= playlist.size():
		return
		
	current_track_index = index
	var file_path = playlist[index]
	var stream = load_external_audio(file_path)
	
	if stream:
		audio_player.stream = stream
		audio_player.play()
		print("Sekarang memutar: ", file_path.get_file())

# Fungsi untuk skip ke lagu berikutnya
func play_next():
	if playlist.size() == 0: 
		return
	var next_index = (current_track_index + 1) % playlist.size()
	play_track(next_index)

# Fungsi untuk dipanggil dari skrip lain saat pergantian level
func skip_to_next_track():
	# Hentikan lagu yang sedang diputar saat ini
	if audio_player.playing:
		audio_player.stop()
	
	print("Level berganti, melewati lagu...")
	# Langsung putar lagu selanjutnya
	play_next()

# Callback otomatis dari AudioStreamPlayer ketika durasi lagu habis
func _on_audio_player_finished():
	print("Lagu selesai, memutar lagu berikutnya...")
	play_next()
