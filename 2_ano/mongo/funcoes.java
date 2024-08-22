import java.util.HashMap;
import java.util.Map;

public class Funcoes {
    String nome;
    int [] userIds;

    public Map<String, Object> generateObject(int [] userIds; String nome) {
        if (nome != null) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("nome", nome);
            dicionario.put("userIds", userIds);
            return dicionario;
        }
        return null;
    }

}


