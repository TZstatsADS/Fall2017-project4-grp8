import java.io.BufferedReader;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.Vector;

//Adjacent List
class NODE {
int user_id;
Set<Integer> website;  

public NODE (int user_id) { 
this.user_id = user_id;
this.website = new HashSet<Integer>();
}
// Node methods defined 
public int get_id() {
return user_id;
}

public void set_web(Set<Integer> websites) {
this.website.clear();
this.website = websites;
}

public void append_web(int id) {
this.website.add(Integer.valueOf(id));
}

public Set<Integer> get_web() {
return website;
}

}


public class MatrixToList {
	public static void processData(String input_file1, String input_file2,String output_file) throws IOException{
		List<Integer> webIndex=new ArrayList<Integer>();
		int i=0;
		FileReader input = new FileReader(input_file1);
		BufferedReader br = new BufferedReader(input);
		String input_lines = br.readLine();
		while(input_lines!=null){
			String[] split = input_lines.split(" ");
			for(int j=0;j<split.length;j++){
				webIndex.add(i,Integer.parseInt(split[j].replaceAll("\"", "")));
				//System.out.println(webIndex.get(i));
				i++;
			}
			//System.out.println(i);
			input_lines = br.readLine();  
		}
		br.close();
		input.close();
		/**********************************/
		Vector<NODE> user_list;
		
		input = new FileReader(input_file2);
		br = new BufferedReader(input);
		FileOutputStream fso = new FileOutputStream(output_file);
		OutputStreamWriter fileWriter = new OutputStreamWriter(fso,Charset.forName("UTF-8"));
		
		input_lines = br.readLine();
		while(input_lines!=null){
			String[] split2 = input_lines.split(" ");
			int userId=Integer.parseInt(split2[0].replaceAll("\"", ""));
			System.out.println(userId);
			fileWriter.write("\n"+ userId);
			for(int j=1;j<split2.length;j++){
				if(split2[j].equals("1")){
					System.out.println(webIndex.get(j-1));
				    fileWriter.write(" "+webIndex.get(j-1));
				}
					
			} 
			
			
		
		input_lines = br.readLine();  
		}
		br.close();
		input.close();
		fileWriter.close();
		fso.close();
	
	}
	public static void transform(String input_file)throws IOException{
	
		
		
		
	}
	public static void main(String[] args) throws IOException{
		//processData("./webindex.txt","./webtest.txt","./webtestAL.txt");
		//train go fuck you self
		processData("./webindex.txt","./webtrain.txt","./webtrainAL.txt");
	
	}

	
}
