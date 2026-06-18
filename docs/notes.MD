# **Yeni Öğrendiğim Bilgiler Hakkında Küçük Notlar**

### **Blocking vs Non Blocking Assignment**

(=) Blocking style bir clocka bağlı olunmadığında, kodun aynı yazılım dillerindeki gibi yukarıdan aşağı ve birbirini bekleyerek çalışması için kullanılır.

(<=) Non Blockingte ise bir clocka bağlıyız ve işin içinde sinyal vardır. clk geldiğinde tüm değerler asılı kalır ve clk bitişinde paralel olarak atanır.

--- 

### **Donanımda Bölme İşlemi ve Kaydırma Operatörü**

<span style="color: #E06C75;">Donanımda bölme operatörü kullanmak adeta bir cinayettir.</span> Benim gelen sinyalleri en az gecikmeyle işlemem gerekirken bu bana büyük bir gecikme çıkarır. 

O yüzden ">>" kaydırma operatörü kullanılır. 

*Mesela x 2 bitlik bir veri olsa x >> 1 yaparsak x'i 2 ye bölmüş, x >> 2 yaparsak x'i 4 e bölmüş, x >> 3 yaparsak 8 e bölmüş oluruz.*

---

### **Talamus Odaklanma Mekanizması ve Priority Encoder**

İnsan beyninde milyonlarca nöron aynı anda sinyal ürettiğinden dolayı odaklanma mekanizmamız yani Talamus, gelen bu sinyaller arasında öncelik sıralaması yapar. Aynı anda elim kaşınırken elimi fırına soksam vücudum kaşıntıyı hala hisseder mi? 

> <span style="color: #98C379;">Tabii ki hayır. Elimi fırından çıkarma ihtiyacı hisseder.</span>

Bunu da donanımda Priority Encoder ve sinir sistemindeki Eşik Değeri ile açıklarız. Priority Encoder gelen sinyallerden en kritik olanı alır ve çıkışa verir. Normal bir sistemde 2 sinyal geldiğinde sistem hangisini seçeceğini bilemez. 

"always @(*)" kullanarak combinational bir devre içinde clock sinyali beklemeden tıpkı reflekslerimize benzer bir sistem kurgularız. 

Örneğin bir hasta EEG cihazına bağlı olsun ve 4 farklı beyin dalgası kanalımız olsun. MSB (3. bit) hastanın epileptik nöbet sinyalini taşıyor olsun. Diğer kanallar ise normal beyin aktiviteleri. Tasarımımızda kod yapımız aynı şu şekilde olur:

```verilog
always @(*) begin
    if (in[3]) 
        out = 2'b11; //Eğer 3. kanaldan bir sinyal geldiyse diğer kanalları boşver. Çıkışa 3. biti ver
    else if (in[2])
        out = 2'b10; //3. kanal boşsa 2. kanaldaki sinyal önceliklidir
    else if (in[1])
        out = 2'b01;
    else
        out = 2'b00; //else koymamız hayati önem taşır. Eğer else koymazsak sistem latch koyar ve sistemimiz kilitlenir
end
```

---

### **Zamanın Kontrolü: Sequential Devreler ve Clock**

Veriler akarken sinyalleri işleyebilmemiz için zamanı durdurmamız ve verileri adım adım işlememiz gerekir. Burada Sequential Devreler ve Clock en çok işimize yarayanlardır. 

<span style="color: #61AFEF;">*Her clk adeta kalbin kan pompalaması gibi tüm sisteme aynı anda enerji ve emir gönderir.*</span>

Şimdi beynin motor korteksinden gelen bir EEG sinyalini her clockta bir sonraki aşamaya aktaran 2 bitlik bir nöron kaydedici, donanımsal adıyla shift register, tasarlayalım. 

```verilog
always @(posedge clk) begin
    if(reset) begin
        neuron_stage1 <= 0;
        neuron_stage2 <= 0;
    end
    else begin
        neuron_stage1 <= eeg_input; //İlk yükselen kenarda veri 1. aşamaya geçer
        neuron_stage2 <= neuron_stage1; //Aynı anda 1. aşamadaki eski veri 2. aşamaya kayar.
    end
end
```
Shift Register ile Gürültü Temizleme (Filtreleme)
Aslında gürültüyü temizlemek için kullanacağımız filteler bu verileri aynı üstteki koddaki gibi sırasıyla kaydırıp ortalamasını almaktan başka bir şey değil.

---





