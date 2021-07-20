$(function(){
  return $('#user_postcode').jpostal({
    postcode: ['#user_postcode'],
    address: {
      '#user_prefecture_code': '%3' ,
      '#user_address_city': '%4%5',
      '#user_address-street': '%6%7',
    },
  });
});