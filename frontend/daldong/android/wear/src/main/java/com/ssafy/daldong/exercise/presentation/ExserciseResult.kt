import android.content.Context
import android.os.Parcel
import android.os.Parcelable
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.*
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.firstOrNull
import kotlinx.coroutines.flow.map

data class ExerciseResult(
    val time: Int,
    val distance: Int,
    val heartRate: Int,
    val calories: Int,
) : Parcelable {
    // Parcelable 구현 생략
    constructor(parcel: Parcel) : this(
        parcel.readInt(),
        parcel.readInt(),
        parcel.readInt(),
        parcel.readInt()
    ) {

    }
    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeInt(time)
        parcel.writeInt(distance)
        parcel.writeInt(heartRate)
        parcel.writeInt(calories)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<ExerciseResult> {
        override fun createFromParcel(parcel: Parcel): ExerciseResult {
            return ExerciseResult(parcel)
        }

        override fun newArray(size: Int): Array<ExerciseResult?> {
            return arrayOfNulls(size)
        }
    }
}
