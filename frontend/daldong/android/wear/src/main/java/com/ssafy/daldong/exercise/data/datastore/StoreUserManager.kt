package com.ssafy.daldong.exercise.data.datastore

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map


class StoreUserManager(
    private val dataStore: DataStore<Preferences>
) {
    companion object {
        val U_ID = stringPreferencesKey("USER_ID")
        val PET_NAME = stringPreferencesKey("PET_NAME")
        val PET_IMG = stringPreferencesKey("PET_IMG")
    }

    suspend fun storeUser(
        pref_uId: String,
        pref_petCustomName: String,
        pref_petGifName: String,
    ) {
        dataStore.edit {
            it[U_ID] = pref_uId
            it[PET_NAME] = pref_petCustomName
            it[PET_IMG] = pref_petGifName
        }
    }

    val userIdFlow: Flow<String?> = dataStore.data.map {
        it[U_ID]
    }

    val petNameFlow: Flow<String?> = dataStore.data.map {
        it[PET_NAME]
    }

    val petImgFlow: Flow<String?> = dataStore.data.map {
        it[PET_IMG]
    }
}

