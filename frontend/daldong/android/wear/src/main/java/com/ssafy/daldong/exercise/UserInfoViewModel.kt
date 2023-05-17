import android.app.Application
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

    private val _petNamePng = MutableLiveData<String>()
    val petNamePng: LiveData<String>
        get() = _petNamePng

    private val _petNameGif = MutableLiveData<String>()
    val petNameGif: LiveData<String>
        get() = _petNameGif

    private val _uId = MutableLiveData<String>()
    val uId: LiveData<String>
        get() = _uId

    override fun onDataChanged(dataEventBuffer: DataEventBuffer) {
        for (event in dataEventBuffer) {
            if (event.type == DataEvent.TYPE_CHANGED && event.dataItem.uri.path == "/PetInfo") {
                val dataMap = event.dataItem.data?.let { DataMap.fromByteArray(it) }

                // 데이터 수신 처리
                val mainUId = dataMap!!.getString("uid")
                val mainPetCustomName = dataMap.getString("mainPetCustomName")
                val mainPetName = dataMap.getString("mainPetName")

                // petCustomName, petName 변경 처리
                _uId.value = mainUId
                _petCustomName.value = mainPetCustomName
                _petNamePng.value = mainPetName + "_png"
                _petNameGif.value = mainPetName + "_gif"
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

    // 나머지 메서드 구현
}