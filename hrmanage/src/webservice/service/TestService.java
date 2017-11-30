package webservice.service;

import javax.jws.WebService;
import javax.xml.ws.Endpoint;

@WebService
public class TestService {

   public String getValue(String name) {
      return "我叫" + name;
   }

   public static void main(String[] args) {
      Endpoint.publish("http://localhost:18080/Service/TestService", new TestService());
      System.out.println("success");
   }
}
