import android.app.Application
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.CapabilityInfo
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataMap

class UserInfoViewModel(application: Application) :
    AndroidViewModel(application),
    DataClient.OnDataChangedListener,
    MessageClient.OnMessageReceivedListener,
    CapabilityClient.OnCapabilityChangedListener {

    private val _petCustomName = MutableLiveData<String>()
    val petCustomName: LiveData<String>
        get() = _petCustomName

    private val _petGifName = MutableLiveData<String>()
    val petGifName: LiveData<String>
        get() = _petGifName

    private val _userId = MutableLiveData<String>()
    val userId: LiveData<String>
        get() = _userId

    override fun onDataChanged(dataEventBuffer: DataEventBuffer) {
        for (event in dataEventBuffer) {
            if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == PET_INIT_PATH) {
                val dataMap = event.dataItem.data?.let { DataMap.fromByteArray(it) }

                // 데이터 수신 처리
                val uId = dataMap!!.getString("uid")
                val mainPetCustomName = dataMap.getString("mainPetCustomName")
                val mainPetName = dataMap.getString("mainPetName")

                // petCustomName, petName 변경 처리
                _userId.value = uId
                _petCustomName.value = mainPetCustomName
                _petGifName.value = mainPetName

                Log.d(TAG, "PetInit: $uId, $mainPetCustomName, $mainPetName")
            }
            else if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == PET_CHANGE_COSTOM_NAME) {
                val dataMap = event.dataItem.data?.let { DataMap.fromByteArray(it) }

                // 데이터 수신 처리
                val mainPetCustomName = dataMap!!.getString("mainPetCustomName")
                _petCustomName.value = mainPetCustomName

                Log.d(TAG, "펫 이름 변경 성공: $mainPetCustomName")
            }
        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        // 메시지 수신 처리 로직 구현
        // ...
    }

    override fun onCapabilityChanged(capabilityInfo: CapabilityInfo) {
        // Capability 변경 처리 로직 구현
        // ...
    }
    companion object {
        private const val TAG = "워치 유저 정보 뷰모델"
        private val PET_INIT_PATH = "/PetInit"
        private val PET_CHANGE_COSTOM_NAME = "/PetChangeCostomName"

//        private val countInterval = Duration.ofSeconds(5)
    }
}