import 'package:flutter/material.dart';

class DialogHelper {
  static void showLongTextDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'คู่มือการใช้งาน DiaBo',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  '1. ข้อบ่งชี้ในการใช้งาน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   1.1 ข้อบ่งใช้',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '     แอปพลิเคชัน DiaBo ถูกพัฒนาเพื่อสนับสนุนการดูแลตัวเองสำหรับผู้ป่วยโรคเบาหวานชนิดที่ 2 ผ่านการจัดการข้อมูลที่เกี่ยวข้องกับโรคเบาหวานประจำวัน โดยมีวัตถุประสงค์เพื่อส่งเสริมให้ผู้ใช้งานมีการดูแลตนเองอย่างต่อเนื่องและมีประสิทธิภาพ ท่านสามารถบันทึกนัดหมายการพบแพทย์ การตั้งเตือนการรับประทานยา บันทึกข้อมูลจากใบผลตรวจทางการแพทย์ รวมถึงคำนวณปริมาณคาร์บในอาหารที่ท่านรับประทานในแต่ละวัน',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '   1.2 DiaBo เหมาะสำหรับบุคคลใด',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '     แอปพลิเคชัน DiaBo ถูกออกแบบมาเพื่อบุคคลที่:\n'
                  '     • ได้รับการวินิจฉัยว่าเป็นโรคเบาหวานชนิดที่ 2\n'
                  '     • มีสภาพร่างกายและจิตใจที่สามารถจัดการการบำบัดโรคเบาหวานได้ด้วยตนเอง\n'
                  '     • สามารถใช้สมาร์ทโฟนได้',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '2. ข้อห้ามใช้',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   ยังไม่มีข้อมูลเกี่ยวกับข้อห้ามการใช้งานในปัจจุบัน',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '3. คำเตือน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   แอปพลิเคชัน DiaBo เป็นเครื่องมือช่วยในการดูแลตัวเองสำหรับผู้ป่วยโรคเบาหวานชนิดที่ 2 เท่านั้น ไม่สามารถใช้ทดแทนการพบแพทย์หรือทีมดูแลผู้ป่วยเบาหวานของท่านได้',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '4. คุณสมบัติเด่น',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   4.1 สรุป',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '     DiaBo ได้รับการออกแบบมาเพื่อทำให้การจัดการโรคเบาหวานในแต่ละวันของท่านง่ายขึ้น และเพิ่มประสิทธิภาพในการดูแลตนเองสำหรับผู้ป่วยโรคเบาหวานโดยรวม อย่างไรก็ตาม สิ่งนี้จะเป็นไปได้ก็ต่อเมื่อท่านมีบทบาทในการดูแลตัวเองอย่างแข็งขัน และให้ข้อมูลที่ถูกต้องและครบถ้วนในแอปพลิเคชัน',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '   4.2 คุณสมบัติหลักของ DiaBo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '     • หน้าจอการบันทึกข้อมูลส่วนตัว\n'
                  '     • คำนวณคาร์บที่ท่านควรได้รับในแต่ละมื้อ/วัน\n'
                  '     • ฟังก์ชันถ่ายภาพที่มีประโยชน์\n'
                  '     • การแจ้งเตือนการรับประทานยา\n'
                  '     • บันทึกข้อมูลจากใบผลตรวจจากแพทย์\n'
                  '     • การแจ้งเตือนนัดหมายการพบแพทย์',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '5. เริ่มต้นใช้งาน',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   5.1 การเริ่มต้นใช้งาน',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '       • การลงทะเบียนสำหรับสมาชิกใหม่ (กรณีที่ยังไม่ได้ทำการลงทะเบียน)\n'
                  '           1.	เปิดแอป DiaBo และเลือก "Sign up"\n'
                  '           2.	กรอกข้อมูลส่วนตัว ได้แก่ ชื่อ-นามสกุล, Username, Gmail, Password, น้ำหนัก, ส่วนสูง และเพศ\n'
                  '           3.	กด "Sign up" เพื่อทำการยืนยันการลงทะเบียน',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '       • การเข้าสู่ระบบ (กรณีที่ทำการลงทะเบียนแล้ว)\n'
                  '           1.	เปิดแอป DiaBo และเลือก "Login"\n'
                  '           2.	กรอก Gmail และ Password ที่ได้ลงทะเบียนไว้\n'
                  '           3.	กด "Login" เพื่อเข้าใช้งานแอป',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '   5.2 การใช้งานฟังก์ชันหลัก',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '       • แจ้งเตือนการพบแพทย์\n'
                  '           1.	เปิดแอปและไปที่หน้า "แจ้งเตือนการพบแพทย์"\n'
                  '           2.	เลือกปุ่มกล้องที่มุมขวาล่าง เพื่อทำการถ่ายภาพใบนัดหมายการพบแพทย์\n'
                  '           3.	\n',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '       • บันทึกผล Lab\n'
                  '           1.	เปิดแอปและไปที่หน้า "ผล Lab"\n'
                  '           2.	เลือกปุ่มกล้องที่มุมขวาล่าง เพื่อทำการถ่ายภาพใบผลตรวจจากแพทย์\n'
                  '           3.	\n',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '       • คำนวณและบันทึกอาหาร\n'
                  '           1.	เปิดแอปและไปที่หน้า "อาหาร"\n'
                  '           2.	เลือกปุ่มกล้องที่มุมขวาล่าง เพื่อทำการถ่ายภาพอาหารเพื่อคำนวณคาร์บ\n'
                  '           3.	กดเลือกมื้ออาหารที่ต้องการเก็บค่า แล้วกดปุ่ม "ถ่ายรูป"\n'
                  '           4.	ทำการถ่ายรูป จากนั้นผลคาร์บและชื่อของอาหารนั้นจะแสดงที่มื้ออาหารที่ท่านเลือก\n'
                  '           5.	วงกลมเปอร์เซ็นต์ด้านบนมื้ออาหารต่าง ๆ บ่งบอกว่าท่านทานคาร์บไปเท่าไหร่จากที่คำนวณไว้\n'
                  '           6.	ปุ่มลูกศรหมุนไปทางซ้ายจะเปิดประวัติการทานคาร์บทั้งหมด\n'
                  '           7.	ปุ่มกราฟแท่งจะแสดงกราฟข้อมูลการรับประทานคาร์บในช่วง 14 วัน และ 1 เดือนที่ผ่านมา\n'
                  '           8.	ปุ่มเครื่องพิมพ์มุมขวาล่างจะทำการแปลงข้อมูลกราฟให้เป็นไฟล์ PDF\n',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '       • แจ้งเตือนการรับประทานยา\n'
                  '           1.	เปิดแอปและไปที่หน้า "แจ้งเตือนการรับประทานยา"\n'
                  '           2.	เลือกปุ่มเครื่องหมายบวกมุมขวาล่างเพื่อทำการตั้งเวลาและโน๊ต\n'
                  '           3.	เลือกเวลาที่ต้องการตั้งเตือน และกรอกโน๊ต (ไม่จำเป็น)\n'
                  '               3.1. เวลาจะเป็นรูปแบบ 12 ชั่วโมง (12-hour format) ซึ่งมีเลขจาก 1 ถึง 12 เท่านั้น การนับเวลาเป็นไปตามระบบสากล โดยจะใช้ AM และ PM ดังนี้:\n'
                  '                 AM หมายถึงช่วงเวลาตั้งแต่ 00:00 น. ถึง 12:00 น. ตามเวลาของประเทศไทย\n'
                  '                 PM หมายถึงช่วงเวลาตั้งแต่ 13:00 น. ถึง 00:00 น. ตามเวลาของประเทศไทย\n'
                  '               3.2. การตั้งเวลาในแอปจะประกอบด้วย:\n'
                  '                 เลขแรกที่แสดงเป็น ชั่วโมง\n'
                  '                 เลขที่สองคือ นาที\n'
                  '           4.	กด "ตกลง" เพื่อบันทึกการแจ้งเตือน\n'
                  '           5.	สามารถเปิดหรือปิดการแจ้งเตือนโดยใช้สวิตซ์ขวามือ\n'
                  '           6.	หากต้องการลบการแจ้งเตือน ให้สไลด์การแจ้งเตือนไปทางซ้ายและกดยืนยันการลบ\n',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '6. ฟังก์ชันพิเศษ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '   6.1 การแก้ไขข้อมูลส่วนตัว',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '           1.	เปิดแอปและไปที่หน้า "การแก้ไขข้อมูลส่วนตัว"\n'
                  '           2.	เปลี่ยนข้อมูลที่ต้องการแก้ไข\n'
                  '           3.	กด "Save Changes" เพื่อบันทึกการเปลี่ยนแปลง\n'
                  '           4.	กดปุ่ม "ย้อนกลับ" เพื่อกลับไปยังหน้าหลัก',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '   6.2 คู่มือการใช้งาน',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '           1.	เปิดแอปและไปที่หน้า "คู่มือการใช้งาน"\n'
                  '           2.	อ่านคู่มือการใช้งานแอปพลิเคชัน\n'
                  '           3.	เมื่ออ่านเสร็จแล้ว กดปุ่ม "รับทราบ" เพื่อออกจากหน้าคู่มือ',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 6),
                Text(
                  '   6.3 การออกจากระบบ',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  '           1.  ไปที่ไอคอน "ออกจากระบบ" ขวามือบนของแอปพลิเคชัน\n'
                  '           2.	กด "ออกจากระบบ" เพื่อกลับไปยังหน้าการเลือก Sign up/Login\n',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Text(
                  '________________________________________\n'
                  'ขอบคุณที่เลือกใช้แอปพลิเคชัน DiaBo จากผู้พัฒนา',
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child:
                  const Text('รับทราบ', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
