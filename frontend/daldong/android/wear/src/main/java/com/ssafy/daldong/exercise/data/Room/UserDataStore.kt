package com.ssafy.daldong.exercise.data.Room

import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
//import androidx.datastore.preferences.createDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class UserDataStore(context: Context) {

//    private val applicationContext = context.applicationContext
//    private val dataStore: DataStore<Preferences> =
//        applicationContext.createDataStore(name = "user_preferences")
//
//    val uIdFlow: Flow<String?>
//        get() = dataStore.data.map { preferences ->
//            preferences[UIdKey] // "uId" 키에 해당하는 값을 반환합니다.
//        }
//
//    val petNameFlow: Flow<String?>
//        get() = dataStore.data.map { preferences ->
//            preferences[PetNameKey] // "petName" 키에 해당하는 값을 반환합니다.
//        }
//
//    val petImgFlow: Flow<String?>
//        get() = dataStore.data.map { preferences ->
//            preferences[PetImgKey] // "petImg" 키에 해당하는 값을 반환합니다.
//        }
//
//    suspend fun setUser(uId: String, petName: String, petImg: String) {
//        dataStore.edit { preferences ->
//            preferences[UIdKey] = uId
//            preferences[PetNameKey] = petName
//            preferences[PetImgKey] = petImg
//        }
//    }
//
//    private object PreferencesKeys {
//        val UIdKey = stringPreferencesKey("uId")
//        val PetNameKey = stringPreferencesKey("petName")
//        val PetImgKey = stringPreferencesKey("petImg")
//    }
//
//    companion object {
//        private val Context.applicationContext: Context
//            get() = applicationContext
//    }
}