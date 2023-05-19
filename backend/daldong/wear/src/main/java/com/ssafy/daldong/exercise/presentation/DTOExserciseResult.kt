import android.os.Parcel
import android.os.Parcelable

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
