/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.ev.esencialverde.data;

import com.microsoft.sqlserver.jdbc.SQLServerDataTable;
import com.microsoft.sqlserver.jdbc.SQLServerPreparedStatement;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Daniel Granados <dagranados@estudiantec.cr>
 */


public class EsencialVerdeAccess implements IDataConstants{
   private static EsencialVerdeAccess instance;
   private Connection conexion;
   
   private EsencialVerdeAccess(){
       try {
               conexion = DriverManager.getConnection(CONN_STRING);
       } catch (Exception ex){
           ex.printStackTrace();
       }
   }
   
   public synchronized static EsencialVerdeAccess getInstance() {
       if (instance == null){
           instance = new EsencialVerdeAccess();
       }
       return instance;
   }

   public void getQuery(String SQL){
       try {
            Statement stmt = conexion.createStatement();
            // String SQL = "SELECT localId, nombre FROM dbo.locales";
            ResultSet rs = stmt.executeQuery(SQL);
            /*
            while (rs.next()){
                System.out.println(rs.getString("localId") + " " + rs.getString("nombre"));
            }*/
       } catch (Exception ex){
           ex.printStackTrace();
       }
   }
   private ResultSet callSP(String sql){
       try {
            CallableStatement cstmt = conexion.prepareCall(sql);

            ResultSet rs = cstmt.executeQuery();
            return rs;
       } catch (Exception ex){
           ex.printStackTrace();
           return null;
       }
   }
   
   public void registrarVenta(SQLServerDataTable sourceDataTable){
         try {
            SQLServerPreparedStatement pStmt =
            (SQLServerPreparedStatement) conexion.prepareStatement("EXEC dbo.SP_registrarFacturaProductos ?;");  
            pStmt.setStructured(1, "dbo.productosTabla", sourceDataTable);  
            pStmt.execute(); 
            } catch (Exception e) {
                  e.printStackTrace(System.out);
                  return;
            }
          
   }
    public ResultSet getProductos(){
       try {
            ResultSet rs = callSP("{call dbo.SP_getProductos}");
            /*
            while (rs.next()){
                System.out.print(rs.getString("productoId") + " " + rs.getString("nombreBase") + " ");
            }*/
            return rs;
       } catch (Exception ex){
           ex.printStackTrace();
           return null;
       }
   }
   
    public ResultSet getCanales(){
       try {
            ResultSet rs = callSP("{call dbo.SP_getCanales}");
            /*while (rs.next()){
                System.out.println(rs.getString("canalId") + " " + rs.getString("nombre"));
            }*/
            return rs;
       } catch (Exception ex){
           ex.printStackTrace();
           return null;
       }
    }
    
    public ResultSet getLotes(){
       try {
            ResultSet rs = callSP("{call dbo.SP_getLotes}");
            /* while (rs.next()){
                System.out.println(rs.getString("loteId") + " " + rs.getString("fecha") + " " + rs.getString("productoNombre")
                        + " " + rs.getString("prodContratoId") + " " + rs.getString("plantaId") + " " + rs.getString("cantidad")
                 + " " + rs.getString("costoProduccion") + " " + rs.getString("precio"));
            }*/
            return rs;
       } catch (Exception ex){
           ex.printStackTrace();
           return null;
       }
    }
}