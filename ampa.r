# ampa.r - Apple Music Play Activity for R
# Version 0.1

library("dplyr")
library("readr")
library("stringr")

# Renames columns of play activity data frames.
rename_ampa_columns <- function(df) {
    df <- df %>%
    rename("artist_name" = "Artist Name", "song_title" = "Song Name",
        "play_duration" = "Play Duration Milliseconds",
        "event_received" = "Event Received Timestamp",
        "apple_id_number" = "Apple ID Number",
        "apple_music_subscription" = "Apple Music Subscription",
        "build_version" = "Build Version",
        "client_ip_address" = "Client IP Address",
        "device_id" = "Device Identifier",
        "end_position" = "End Position In Milliseconds",
        "end_reason_type" = "End Reason Type",
        "event_end" = "Event End Timestamp",
        "event_reason_hint_type" = "Event Reason Hint Type",
        "event_start" = "Event Start Timestamp",
        "event_type" = "Event Type",
        "feature_name" = "Feature Name",
        "item_type" = "Item Type",
        "media_duration" = "Media Duration In Milliseconds",
        "media_type" = "Media Type",
        "metrics_bucket_id" = "Metrics Bucket Id",
        "metrics_client_id" = "Metrics Client Id",
        "milliseconds_since_play" = "Milliseconds Since Play",
        "offline" = "Offline",
        "provided_audio_bit_depth" = "Provided Audio Bit Depth",
        "provided_audio_channel" = "Provided Audio Channel",
        "provided_audio_sample_rate" = "Provided Audio Sample Rate",
        "provided_bit_rate" = "Provided Bit Rate",
        "provided_codec" = "Provided Codec",
        "provided_playback_format" = "Provided Playback Format",
        "shared_session" = "Session Is Shared",
        "current_shared_activity_devices" = "Shared Activity Devices-Current",
        "max_shared_activity_devices" = "Shared Activity Devices-Max",
        "source_type" = "Source Type",
        "start_position_in_milliseconds" = "Start Position In Milliseconds",
        "store_front_name" = "Store Front Name",
        "users_audio_quality" = "User’s Audio Quality",
        "users_playback_format" = "User’s Playback Format",
        "utc_offset" = "UTC Offset In Seconds")
    return(df)
}

# Opens a play activity file (csv) and renames the columns.
open_ampa_csv <- function(filename) {
    return(rename_ampa_columns(read_csv(filename)))
}

# Returns a data frame containing the total play length of unique songs.
song_lengths <- function(df) {
    # Select PLAY_END event types. (Is this correct?)
    df <- df[df$event_type == "PLAY_END", ]

    # Create table
    df <- aggregate(play_duration ~ song_title + artist_name, data = df,
        FUN = sum, na.rm = TRUE)
    df <- df %>% arrange(desc(play_duration))

    return(df)
}

# Returns a data frame containing activity history for a specific artist.
filter_artist <- function(df, artist_name) {
    df <- df[df$artist_name == artist_name, ]
    return(df)
}

# Returns a data frame containing activity history on a specific date.
filter_date <- function(df, date) {
    date <- as.Date(date)
    df$event_received <- as.Date(df$event_received)
    df <- df[df$event_received == date, ]
    return(df)
}

# Returns a data frame containing activity history between two specific dates.
filter_dates <- function(df, begin_date, end_date) {
    begin_date <- as.Date(begin_date)
    end_date <- as.Date(begin_date)
    df$event_received <- as.Date(df$event_received)
    df <- df[df$event_received >= begin_date & df$event_received <= end_date, ]
    return(df)
}

# Returns a data frame containing activity history for a specific song and
# artist.
filter_song <- function(df, song_title, artist_name) {
    df <- df[df$song_title == song_title & df$artist_name == artist_name, ]
    return(df)
}

# Returns a data frame with unique song titles and artist names.
unique_songs <- function(df) {
    df <- df %>% select("artist_name", "song_title")
    df <- df %>% distinct()
    return(df)
}
