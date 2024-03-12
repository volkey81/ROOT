package com.sanghafarm.service.product;

import java.util.List;

import com.efusioni.stone.ibatis.IbatisService;
import com.efusioni.stone.utils.Param;

public class ProductService extends IbatisService {
	
	public Param getInfo(String pid) {
		return getInfo(new Param("pid", pid));
	}
	
	public Param getInfo(Param param) {
		return super._row("Product.getInfo", param);
	}
	public Param getPidForRootCateseq(int cateSeq) {
		return super._row("Product.getPidForRootCateseq", cateSeq);
	}
	public int getCateSeqForPid(String pid) {
		return (Integer) super._scalar("Product.getCateSeqForPid", pid);
	}
	
	public List<Param> getDeliveryDayList(String pid) {
		return super._list("Product.getDeliveryDayList", pid);
	}

	public List<Param> getDeliveryDateList(String pid) {
		List<Param> list = super._list("Product.getDeliveryDateList", pid);
		if(list == null || list.size() == 0) {
			Param param = new Param();
			param.addPaging(1, 10);
			list = super._list("ShipDate.getShipDateList", param);
		}
		return list;
	}
	
	public List<Param> getOptionList(Param param) {
		return super._list("Product.getOptionList", param);
	}

	public List<Param> getRefList(String pid) {
		return getRefList(new Param("pid", pid));
	}
	
	public List<Param> getRefList(Param param) {
		return super._list("Product.getRefList", param);
	}
	
	public List<Param> getIconList(String pid) {
		return super._list("Product.getIconList", pid);
	}
	
	public List<Param> getRoutineSaleList(String pid) {
		return super._list("Product.getRoutineSaleList", pid);
	}
	
	public List<Param> getList(Param param) {
		return super._list("Product.getList", param);
	}
	
	public Integer getListCount(Param param) {
		return (Integer) super._scalar("Product.getListCount", param);
	}
	
	public void mergeToRecentProduct(Param param) {
		super._update("Product.mergeToRecentProduct", param);
	}
	
	public List<Param> getRecentProduct(Param param) {
		return super._list("Product.getRecentProduct", param);
	}
	
	public Integer getRecentProductCount(String userId) {
		return (Integer) super._scalar("Product.getRecentProductCount", userId);
	}
	
	public void removeRecentProduct(Param param) {
		super._delete("Product.deleteRecentProduct", param);
	}
	
	public List<Param> getRefProductList(Param param) {
		return super._list("Product.getRefProductList", param);
	}
	
	public List<Param> getProductCateList(String pid) {
		return super._list("Product.getProductCateList", pid);
	}
}
